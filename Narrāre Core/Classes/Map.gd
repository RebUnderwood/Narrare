extends Node
class_name Map


@export var current_room: Room = null;

func set_current_room(in_room_name: String) -> Error:
	for room in get_children():
		if room.room_name == in_room_name:
			current_room = room;
			return OK;
	return FAILED;

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
	pass;

func _on_room_says(message: String) -> void:
	Narrare.say(message);
