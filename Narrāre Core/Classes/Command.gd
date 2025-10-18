extends Node
class_name Command

var _command_regex = RegEx.new();
var _callable: Callable = func(_interactables: Dictionary, _matches: RegExMatch) -> String: return "";

func _init(regex_string: String, in_callable: Callable) -> void:
	_command_regex.compile(regex_string, true);
	_callable = in_callable;
	
func attempt_match_execute(input_string: String, interactables: InteractablesInterface) -> Variant:
	var regex_match: RegExMatch = _command_regex.search(input_string);
	if regex_match == null:
		return null;
	else:
		return _callable.call(interactables, regex_match);
	
