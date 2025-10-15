extends Node
class_name Command

var command_regex = RegEx.new();
var callable: Callable = func(_interactables: Dictionary, _matches: RegExMatch) -> String: return "";

func _init(regex_string: String, in_callable: Callable) -> void:
	command_regex.compile(regex_string, true);
	callable = in_callable;
	
func attempt_match_execute(input_string: String, interactables: Dictionary) -> Variant:
	var regex_match: RegExMatch = command_regex.search(input_string);
	if regex_match == null:
		return null;
	else:
		return callable.call(interactables, regex_match);
	
