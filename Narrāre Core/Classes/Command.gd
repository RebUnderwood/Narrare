extends Node
class_name Command

var command_name: String = "";
var _command_regex = RegEx.new();
var _callable: Callable = func(_interactables: Dictionary, _matches: RegExMatch) -> String: return "";

func _init(in_name: String, regex_string: String, in_callable: Callable) -> void:
	command_name = in_name;
	_command_regex.compile(regex_string, true);
	_callable = in_callable;
	
func attempt_match_execute(input_string: String, interactables: InteractablesInterface, restricted_commands: Array[String]) -> Variant:
	var regex_match: RegExMatch = _command_regex.search(input_string);
	if regex_match == null:
		return null;
	elif restricted_commands.has(command_name):
		return "This command is unavailable.";
	else:
		return _callable.call(interactables, regex_match);
	
