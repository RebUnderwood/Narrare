extends Node
class_name Interactable

@export var identifier: String;

var _interactions: Dictionary[String, Callable] = {}

func _init(in_identifier: String) -> void:
	identifier = in_identifier;
	
func add_interaction(interaction_identifier: String, interaction: Callable) -> Interactable:
	_interactions[interaction_identifier] = interaction;
	return self;
	
func attempt_interaction(interaction_identifier: String, args: Array) -> Variant:
	if _interactions.has(interaction_identifier):
		return _interactions[interaction_identifier].callv(args);
	else:
		return null;
