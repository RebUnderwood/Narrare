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

func navigate(direction: Narrare.Direction) -> Variant:
	var next_room: Room = current_room.get_room_in_direction(direction);
	if next_room == null:
		return null;
	else:
		var previous_room = current_room;
		previous_room.exit_trigger();
		current_room = next_room;
		current_room.enter_trigger();
		return current_room.enter(previous_room);
	
func get_room_description(in_room: Room = current_room) -> String:
	return "[b]" + in_room.room_name + "[/b]\n" + in_room.look();

func _ready() -> void:
	Narrare.set_map(self);
