extends Node
class_name Interactable

@export var identifier: String;
@export var interactions: Dictionary[String, Callable] = {}

func _init(in_identifier: String) -> void:
	identifier = in_identifier;
	
func add_interaction(interaction_identifier: String, interaction: Callable) -> Interactable:
	interactions[interaction_identifier] = interaction;
	return self;
	
func attempt_interaction(interaction_identifier: String, args: Array) -> Variant:
	if interactions.has(interaction_identifier):
		return interactions[interaction_identifier].callv(args);
	else:
		return null;
