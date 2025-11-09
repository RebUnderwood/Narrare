extends Node

enum Direction {NONE, NORTH, NORTHWEST, WEST, SOUTHWEST, SOUTH, SOUTHEAST, EAST, NORTHEAST, UP, DOWN}

signal say_something(message: String);
signal input_something(message: String, clear: bool);
signal set_enable_input(enable: bool);
signal clear_output;
@warning_ignore("unused_signal")
signal done_writing_to_output;
@warning_ignore("unused_signal")
signal done_writing_to_input;
@warning_ignore("unused_signal")
signal input_text_changed(text: String);
signal prompt_changed(is_prompt: bool);
signal input_request_changed(is_input_request: bool);
signal loaded_game();
signal game_over();

var map: Map;
var previous_text_displayed: String = "";
var data_saved: bool = true;
var current_prompt: Prompt = null:
	set(val):
		current_prompt = val;
		prompt_changed.emit(val != null);
var current_input_request: InputRequest = null:
	set(val):
		current_input_request = val;
		input_request_changed.emit(val != null);

func say(message: String) -> void:
	say_something.emit(message);
	
func clear() -> void:
	clear_output.emit();
	
func say_to_input(message: String, in_clear: bool = true) -> void:
	input_something.emit(message, in_clear);
	
func disable_input() -> void:
	set_enable_input.emit(false);
	
func enable_input() -> void:
	set_enable_input.emit(true);
	
func set_map(in_map: Map) -> void:
	map = in_map;
	
func collect_available_interactables() -> InteractablesInterface:
	var interactables: InteractablesInterface = InteractablesInterface.new();
	for interactable_name in Narrare.map.current_room.interactables:
		var interactable = Interactables.get_interactable(interactable_name);
		
		if interactable != null:
			interactables.add_interactable(interactable);
		else:
			var room_interactable = Narrare.map.current_room.room_interactables.get_interactable(interactable_name);
			if room_interactable != null:
				interactables.add_interactable(room_interactable);
	for interactable_name in Data.player_inventory:
		var interactable = Interactables.get_interactable(interactable_name);
		if interactable != null:
			interactables.add_interactable(interactable);
	for interactable_name in Interactables.get_global_interactables():
		var interactable = Interactables.get_interactable(interactable_name);
		if interactable != null:
			interactables.add_interactable(interactable);
	return interactables;
	
func trigger_game_over() -> void:
	game_over.emit();

# === Saving and Loading ===
func save(save_name: String = "-----") -> int:
	save_name = save_name.replace_chars('_ ', '-'.unicode_at(0));
	if !DirAccess.dir_exists_absolute("user://Saves"):
		var dir_made: Error = DirAccess.make_dir_absolute("user://Saves")
		if dir_made != OK:
			return -1;
	var save_dir = DirAccess.open("user://Saves");
	var existing_saves: PackedStringArray = save_dir.get_files();
	var save_dict: Dictionary = {
		"save_name": save_name,
		"save_time": Time.get_unix_time_from_system(),
		"current_room": map.current_room.room_name,
		"previous_text_displayed": previous_text_displayed,
		"data": Data.to_dict(),
		"global_interactables": Interactables.get_global_interactables(),
		"restricted_commands": Commands.get_restricted_commands()
	};
	var json_save: String = JSON.stringify(save_dict);
	var save_num = existing_saves.size();
	var file_name: String = "user://Saves/%d_%d_%s.save" % [save_num, save_dict.save_time, save_name];
	var save_file = FileAccess.open(file_name, FileAccess.WRITE)
	if !save_file.store_string(json_save):
		return -1;
	data_saved = true;
	return save_num;
	
func list_saves() -> String:
	var out: String = "To load a save, type, 'load <save number>'.\n\n"
	out += "-----------------------[b]SAVES[/b]-----------------------\n" ;
	if !DirAccess.dir_exists_absolute("user://Saves"):
		out += "No saves found!\n";
	else:
		var save_dir = DirAccess.open("user://Saves");
		var existing_saves: Array[String];
		existing_saves.assign(save_dir.get_files());
		existing_saves.sort_custom((
			func(a, b) -> bool:
				var save_a: PackedStringArray = a.split("_");
				var save_b: PackedStringArray = b.split("_");
				if save_b[0].is_valid_int() && save_a[0].is_valid_int():
					return int(save_a[0]) > int(save_b[0]);
				else:
					return false;
		))
		for e_save in existing_saves:
			var save_info: PackedStringArray = e_save.split("_")
			var save_line = "- [%s] (%s) %s\n" % [
				save_info[0],
				Time.get_datetime_string_from_unix_time(int(save_info[1]), true), 
				save_info[2].get_basename().replace_char('-'.unicode_at(0), ' '.unicode_at(0)),
			];
			out += save_line;
	out += "---------------------------------------------------\n";
	return out;
		
func load_save(save_number: String) -> Dictionary:
	var out_str: String = "";
	if !DirAccess.dir_exists_absolute("user://Saves"):
		return {"err": FAILED, "out": out_str};
	else:
		var save_dir = DirAccess.open("user://Saves");
		var existing_saves: PackedStringArray = save_dir.get_files();
		var no_matching_saves_flag: bool = true;
		for e_save in existing_saves:
			if e_save.begins_with(save_number):
				no_matching_saves_flag = false;
				var file = FileAccess.open("user://Saves/" + e_save, FileAccess.READ)
				var json = JSON.new();
				if json.parse(file.get_as_text()) != OK:
					print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line());
					return {"err": ERR_INVALID_DATA, "out": out_str};
				var save_data = json.data;
				if !save_data.has("data") || !save_data.has("save_name") || !save_data.has("current_room") || !save_data.has("global_interactables") || !save_data.has("restricted_commands"):
					return {"err": ERR_INVALID_DATA, "out": out_str};
				if map.set_current_room_by_name(save_data.current_room) != OK:
					return {"err": ERR_INVALID_DATA, "out": out_str};
				Data.from_dict(save_data.data);
				Interactables.set_global_interactables(Array(save_data.global_interactables, TYPE_STRING, "", null));
				Commands.set_restricted_commands(Array(save_data.restricted_commands, TYPE_STRING, "", null));
				out_str = "Loaded save %s: %s\n\n" % [save_number, save_data.save_name.replace_char('-'.unicode_at(0), ' '.unicode_at(0))];
				if save_data.has("previous_text_displayed"):
					out_str += save_data.previous_text_displayed;
				else:
					out_str += map.get_room_description();
		if no_matching_saves_flag:
			out_str = "There were no saves matching that number to load.";
		else:
			data_saved = true;
	loaded_game.emit();
	return {"err": OK, "out": out_str};
