extends Node
class_name Interactable

var primary_identifier: String;
var identifiers: Array[String];
var specifier: String;

var _interactions: Dictionary[String, Callable] = {}
var on_command_trigger: Callable = func (_a) -> Variant: return null;
var on_load_trigger: Callable = func() -> Variant: return null;
var _revealed_by: Array = [];
var _hidden_by: Array = [];

var interactable_specific_commands: Array[Command] = [];

func _init(in_identifier: String, in_specifier: String = in_identifier) -> void:
	primary_identifier = in_identifier;
	identifiers = [in_identifier];
	specifier = in_specifier;
	
func is_hidden() -> bool:
	var hidden: bool = false;
	
	if _revealed_by.size() != 0:
		for reveal_condition in _revealed_by:
			if !Data.get(reveal_condition):
				hidden = true;
				break;
		
	if _hidden_by.size() != 0 && !hidden:
		hidden = true;
		for hidden_condition in _hidden_by:
			if !Data.get(hidden_condition):
				hidden = false
				break;
		
	return hidden;

func is_revealed_by(...data_condition: Array) -> Interactable:
	_revealed_by = data_condition;
	return self;
	
func is_hidden_by(...data_condition: Array) -> Interactable:
	_hidden_by = data_condition;
	return self;
	
func add_synonyms(...synonymous_identifiers: Array) -> Interactable:
	identifiers.append_array(synonymous_identifiers);
	return self;
		
func add_interaction(interaction_identifier: String, interaction: Callable) -> Interactable:
	var wrapper: Callable = (
		func(...args) -> Variant:
			if is_hidden():
				return null;
			return interaction.callv(args)
			)
	_interactions[interaction_identifier] = wrapper;
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
	
func add_command(command: Command) -> Interactable:
	interactable_specific_commands.push_back(command);
	return self;
	
func add_interaction_synonym(synonym: String, existing_interaction: String, ...args: Array) -> Interactable:
	_interactions[synonym] =(
		func(...func_args: Array) -> Variant:
			func_args.append_array(args)
			return attempt_interaction(existing_interaction, func_args);
			)
	return self;
	
func add_command_synonym(synonym_command_identifier: String, existing_interaction: String, synonym_command_regex: String, ...interaction_args: Array) -> Interactable:
	add_command(Command.new(synonym_command_identifier, synonym_command_regex, (
		func(_a, _b) -> String:
			return attempt_interaction.call(existing_interaction, interaction_args);
			)
		)
	)
	return self;
	
func attempt_interaction(interaction_identifier: String, args: Array) -> Variant:
	if _interactions.has(interaction_identifier):
		return _interactions[interaction_identifier].callv(args);
	else:
		return null;
