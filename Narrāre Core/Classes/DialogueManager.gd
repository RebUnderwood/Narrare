extends Node
class_name DialogueManager

var _dialogue_dict: Dictionary[String, DialogueChain] = {};

func add_chain(identifier: String) -> DialogueChain:
	var new_chain = DialogueChain.new();
	_dialogue_dict[identifier] = new_chain;
	return new_chain;
	
func get_chain(identifier: String) -> DialogueChain:
	return _dialogue_dict[identifier];
	
func get_chain_start(identifier: String) -> Callable:
	return _dialogue_dict[identifier].get_start();
	
func start_chain(identifier: String) -> String:
	return _dialogue_dict[identifier].start();
