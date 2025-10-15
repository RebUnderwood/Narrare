extends Node
class_name CommandsBase

var command_stack: Array[Command] = [];

func parse_command(input_string: String) -> String:
	var out: String = "[color=gray]> %s[/color]\n\n" % input_string;
	input_string = input_string.lstrip(" \t").rstrip(" \t")
	var interactables: Dictionary = {};
	for interactable_name in Narrare.map.current_room.interactables:
		var interactable = Interactables.get_interactable(interactable_name);
		if interactable != null:
			interactables[interactable_name] = interactable;
	for interactable_name in Narrare.player_inventory:
		var interactable = Interactables.get_interactable(interactable_name);
		if interactable != null:
			interactables[interactable_name] = interactable;
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
		out += Narrare.current_input_request.execute_callable(input_string);
		Narrare.current_input_request = null;
		Narrare.data_saved = false;
	#Commands
	else:
		input_string = input_string.to_lower();
		for command in command_stack:
			var result: Variant = command.attempt_match_execute(input_string, interactables);
			if result == null:
				continue;
			else:
				out += result;
				Narrare.data_saved = false;
				return out;
		out += "Unrecognized command. Type 'help' for a list of available commands.";
	return out;
