extends Node
class_name Interactable

var primary_identifier: String;
var identifiers: Array[String];
var specifier: String;

var _interactions: Dictionary[String, Callable] = {}
var on_command_trigger: Callable = func (_a) -> Variant: return null;
var on_load_trigger: Callable = func() -> Variant: return null;
var _revealed_by: Array = [];

func _init(in_identifier: String, in_specifier: String = in_identifier) -> void:
	primary_identifier = in_identifier;
	identifiers = [in_identifier];
	specifier = in_specifier;
	
func is_hidden() -> bool:
	for reveal_condition in _revealed_by:
		if Data.get(reveal_condition):
			return false;
		else:
			return true;
	return false;

func is_revealed_by(...data_condition: Array) -> Interactable:
	_revealed_by = data_condition;
	return self;
	
func add_synonyms(...synonymous_identifiers: Array) -> Interactable:
	identifiers.append_array(synonymous_identifiers);
	return self;
		
func add_interaction(interaction_identifier: String, interaction: Callable) -> Interactable:
	_interactions[interaction_identifier] = interaction;
	return self;
	
func add_basic_interaction(interaction_identifier: String, result: String) -> Interactable:
	_interactions[interaction_identifier] = (
		func(..._a) -> Variant: 
			if is_hidden():
				return null;
			return result;
			);
	return self;
	
func add_basic_conditional_interaction(interaction_identifier: String, data_condition: String, true_result: Variant, false_result: Variant) -> Interactable:
	_interactions[interaction_identifier] = (
		func(..._a) -> Variant: 
			if is_hidden():
				return null;
			if Data.get(data_condition):
				return true_result
			else:
				return false_result
			);
	return self;

func add_on_command_trigger(trigger: Callable) -> Interactable:
	on_command_trigger = trigger;
	return self;
	
func add_on_load_trigger(trigger: Callable) -> Interactable:
	on_load_trigger = trigger;
	return self;
	
func attempt_interaction(interaction_identifier: String, args: Array) -> Variant:
	if _interactions.has(interaction_identifier):
		return _interactions[interaction_identifier].callv(args);
	else:
		return null;
