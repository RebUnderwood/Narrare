extends Node
class_name InteractablesInterface

var _objs: Dictionary[String, Interactable] = {}
	
func get_interactable(interactable_identifier: String) -> Interactable:
	if !_objs.has(interactable_identifier):
		return null;
	else:
		return _objs[interactable_identifier];
		
func get_all_interactables() -> Array[Interactable]:
	return _objs.values();
	
func add_interactable(in_interactable: Interactable) -> void:
	for identifier in in_interactable.identifiers:
		_objs[identifier] = in_interactable;

func add_interactables(in_interactables: Array[Interactable]) -> void:
	for interactable in in_interactables:
		add_interactable(interactable);
		
func attempt_interaction(interactable_identifier: String, interaction_identifier: String, ...args: Array) -> Variant:
	var gotten_interactable: Interactable = get_interactable(interactable_identifier);
	if gotten_interactable == null:
		return null;
	else:
		return gotten_interactable.attempt_interaction(interaction_identifier, args)

func trigger_command_triggers(command_string: String) -> String:
	var out: String = "";
	for interactable in get_all_interactables():
		var addition: Variant = interactable.on_command_trigger.call(command_string);
		if addition is String:
			out += addition;
	return out;
