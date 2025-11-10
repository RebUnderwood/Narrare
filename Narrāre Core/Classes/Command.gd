extends Node
class_name Command

var command_name: String = "";
var _command_regexs: Array[RegEx] = [];
var _callable: Callable = func(_interactables: Dictionary, _matches: RegExMatch) -> String: return "";

func _init(in_name: String, regex_string: String, in_callable: Callable) -> void:
	command_name = in_name;
	var command_regex: RegEx = RegEx.new();
	command_regex.compile(regex_string, true);
	_command_regexs.push_back(command_regex);
	_callable = in_callable;
	
func add_synonym(regex_string: String) -> Command:
	var command_regex: RegEx = RegEx.new();
	command_regex.compile(regex_string, true);
	_command_regexs.push_back(command_regex);
	return self;
	
func attempt_match_execute(input_string: String, interactables: InteractablesInterface, restricted_commands: Array[String]) -> Variant:
	for command_regex in _command_regexs:
		var regex_match: RegExMatch = command_regex.search(input_string);
		if regex_match == null:
			continue;
		elif restricted_commands.has(command_name):
			return "This command is unavailable.";
		else:
			return _callable.call(interactables, regex_match);
	return null;
