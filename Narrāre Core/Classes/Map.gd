extends Node
class_name Map

@export var current_room: Room = null;

func set_current_room(in_room: Room) -> void:
	current_room = in_room;
	
func set_current_room_by_name(room_name: String) -> Error:
	var set_room: Room = get_room_by_name(room_name);
	if set_room == null:
		return FAILED;
	else:
		set_current_room(set_room);
		return OK;
	
func get_room_by_name(room_name: String) -> Room:
	for room in get_children():
		if room is Room && room.room_name == room_name:
			return room;
	return null;
	
func describe_navigation(exit: Exit, entrance: Exit, new_room: Room, load_triggers_result: String = "") -> String:
	var out =  "[b]%s[/b]\n" % new_room.room_name;
	if !exit.on_exit_description.is_empty():
		out += exit.on_exit_description + " ";
	if !entrance.on_enter_description.is_empty():
		out += entrance.on_enter_description + " ";
	if !new_room.entry_description.is_empty():
		out += new_room.entry_description + " ";
	out += new_room.look();
	out += load_triggers_result;
	return out;

func navigate(direction: Narrare.Direction) -> Variant:
	var next_exit: Exit = current_room.get_exit_in_direction(direction);
	if next_exit == null:
		return null;
	var next_entrance_dict: Dictionary = next_exit.leave();
	next_exit.leave_trigger();
	if next_entrance_dict.next_exit == null:
		return next_entrance_dict.description;
	var next_entrance: Exit = next_entrance_dict.next_exit;
	var next_room_dict: Dictionary = next_entrance.enter();
	next_entrance.enter_trigger();
	if next_room_dict.next_room == null:
		return next_room_dict.description;
	var next_room: Room = next_room_dict.next_room;
	var previous_room = current_room;
	previous_room.exit_trigger();
	current_room = next_room;
	current_room.enter_trigger();
	var load_triggers: String = "";
	for interactable in current_room.interactables:
		var trigger_result: Variant = Narrare.collect_available_interactables().get_interactable(interactable).on_load_trigger.call();
		if trigger_result != null:
			load_triggers += trigger_result;
	return describe_navigation(next_exit, next_entrance, current_room, load_triggers);
	
func get_room_description(in_room: Room = current_room) -> String:
	return "[b]" + in_room.room_name + "[/b]\n" + in_room.look();

func _ready() -> void:
	Narrare.set_map(self);
