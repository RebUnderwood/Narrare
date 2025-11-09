extends Node
class_name Exit

@export var direction: Narrare.Direction = Narrare.Direction.NONE;
@export var leads_to: Exit = null;
@export_multiline var on_exit_description: String = "";
@export_multiline var on_enter_description: String = "";
@export var locking_property: String = "";
@export_multiline var locked_description: String = "This exit is locked.";

var _in_room: Room = null;

func set_room(in_room: Room) -> void:
	_in_room = in_room;

func leave() -> Dictionary:
	var locked: Variant = Data.get(locking_property);
	if !locking_property.is_empty():
		assert (locked != null, "Could not find locking_property '" + locking_property + "' in Data script!")
	else:
		locked = false;
	if !locked:
		return {
			"next_exit": leads_to,
			"description": on_exit_description,
		}
	else:
		return {
			"next_exit": null,
			"description": locked_description,
		}

func enter() -> Dictionary:
	var locked: Variant = Data.get(locking_property);
	if !locking_property.is_empty():
		assert (locked != null, "Could not find locking_property '" + locking_property + "' in Data script!")
	else:
		locked = false;
	if !locked:
		return {
			"next_room": _in_room,
			"description": on_enter_description,
		}
	else:
		return {
			"next_room": null,
			"description": locked_description,
		}

func leave_trigger() -> void:
	pass;
	
func enter_trigger() -> void:
	pass;
