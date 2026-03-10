extends Node
class_name RoomState

var state_name: Variant = null;
var interactables: Array[String] = [];
var room_interactables: InteractablesInterface = InteractablesInterface.new();
var look_description: String = "";
var entry_description: String = "";
var enter_triggers: Array[Callable] = [];
var exit_triggers: Array[Callable] = [];

func enter_trigger() -> void:
	for trigger in enter_triggers:
		trigger.call();
	
func exit_trigger() -> void:
	for trigger in exit_triggers:
		trigger.call();

func set_look_description(in_description: String) -> RoomState:
	look_description = in_description;
	return self;
	
func set_entry_description(in_description: String) -> RoomState:
	entry_description = in_description;
	return self;
	
func add_enter_trigger(trigger: Callable) -> RoomState:
	enter_triggers.push_back(trigger);
	return self;
	
func add_exit_trigger(trigger: Callable) -> RoomState:
	exit_triggers.push_back(trigger);
	return self;
	
func add_interactables(...in_interactables: Array) -> RoomState:
	for interactable in in_interactables:
		if interactable is Interactable:
			interactables.push_back(interactable.primary_identifier);
			room_interactables.add_interactable(interactable);
		elif interactable is String:
			interactables.push_back(interactable);
	return self;
