extends Node
class_name InteractablesInterface

var objs: Dictionary[String, Interactable] = {}
	
func get_interactable(interactable_identifier: String) -> Interactable:
	if !objs.has(interactable_identifier):
		return null;
	else:
		return objs[interactable_identifier];
		
func get_all_interactables() -> Array[Interactable]:
	return objs.values();
	
func add_interactable(in_interactable: Interactable) -> void:
	objs[in_interactable.identifier] = in_interactable;

func add_interactables(in_interactables: Array[Interactable]) -> void:
	for interactable in in_interactables:
		add_interactable(interactable);
		
func attempt_interaction(interactable_identifier: String, interaction_identifier: String, ...args: Array) -> Variant:
	var gotten_interactable: Interactable = get_interactable(interactable_identifier);
	if gotten_interactable == null:
		print("AAAAAAA")
		return null;
	else:
		return gotten_interactable.attempt_interaction(interaction_identifier, args)
