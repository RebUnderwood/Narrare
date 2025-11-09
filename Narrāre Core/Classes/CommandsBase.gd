extends Node
class_name CommandsBase

var command_stack: Array[Command] = [];
var _restricted_commands: Array[String] = [];

func restrict(command_identifier: String) -> void:
	_restricted_commands.push_back(command_identifier);

func unrestrict(command_identifier: String) -> void:
	_restricted_commands.erase(command_identifier);
	
func restrict_array(command_identifier_array: Array[String]) -> void:
	_restricted_commands.append_array(command_identifier_array);

func unrestrict_array(command_identifier_array: Array[String]) -> void:
	for identifier in command_identifier_array:
		_restricted_commands.erase(identifier);
		
func get_restricted_commands() -> Array[String]:
	return _restricted_commands;
	
func set_restricted_commands(command_identifier_array: Array[String]) -> void:
	_restricted_commands = command_identifier_array;

func parse_command(input_string: String) -> String:
	var out: String = "[color=gray]> %s[/color]\n\n" % input_string;
	input_string = input_string.lstrip(" \t").rstrip(" \t")
	var interactables = Narrare.collect_available_interactables();
	# Prompts
	if Narrare.current_prompt != null:
		if !input_string.is_valid_int():
			out += "Please select a numbered option.";
		else:
			var result: Variant = Narrare.current_prompt.execute_option(int(input_string));
			if result == null:
				out += "Not a valid option.";
			else:
				out += result;
				Narrare.current_prompt = null;
				Narrare.data_saved = false;
	# Input Requests
	elif Narrare.current_input_request != null:
		if Narrare.current_input_request is ForcedInput:
			input_string = Narrare.current_input_request.forced_input;
			out = "[color=gray]> %s[/color]\n\n" % input_string;
		var prev_req = Narrare.current_input_request;
		Narrare.current_input_request = null;
		out += prev_req.execute_callable(input_string);
		prev_req.queue_free();
		Narrare.data_saved = false;
	#Commands
	else:
		input_string = input_string.to_lower();
		for command in command_stack:
			var result: Variant = command.attempt_match_execute(input_string, interactables, _restricted_commands);
			if result == null:
				continue;
			else:
				out += result;
				Narrare.data_saved = false;
				var trigger_text: String = interactables.trigger_command_triggers(input_string);
				if !trigger_text.is_empty():
					out += trigger_text;
				return out;
		out += "Unrecognized command. Type 'help' for a list of available commands.";
	return out;

func set_command_stack(in_stack: Array[Command]) -> void:
	command_stack = in_stack;
