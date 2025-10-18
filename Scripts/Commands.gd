extends CommandsBase

# === COMMANDS ===
# This script should contain your game's commands. Commands are
# how the player interacts with the game. For example, a common 
# command in many text-based adventure games is 'go' followed
# by a cardinal direction, which allows movement between rooms.
#
# Commands in Narrāre take the form of Command objects, which
# can be constructed using Command.new(). Command.new() takes two
# arguments. The first is a regular expression in the form of a 
# String. This regular expression should match the syntax of your
# command and any arguments. For a 'go' command, a regular expression
# might look like "^go ?(?'direction_group'[\\w]+)?". For more
# information about how to work with regular expressions in Godot,
# see https://docs.godotengine.org/en/stable/classes/class_regex.html .
#
# The second argument to Command.new() is a Callable. The Callable
# should take two arguments and return a String: 
#
#	func(interactables: InteractablesInterface, matches: RegExMatch) -> String:
#
# The returned String is what will be shown to the player after the 
# command is executed.
#
# 'interactables' is an InteractablesInterface containing all the interactables in
# the current room and the player's inventory, i.e. all the available
# ones. For more on interactables, see Interactables.gd.
#
# 'matches' is a RegExMatch  that is the result of calling RegEx.search()
# with the pattern specified in the first argument of Command.new().
# It is how you will access any matched groups, and thus allows you
# to access a command's arguments as defined by the pattern. For more
# on RegExMatch, see https://docs.godotengine.org/en/stable/classes/class_regexmatch.html#class-regexmatch .
#
# Note that you do not have to check if the inputted command matches 
# the specified pattern within the Callable; this check is done by 
# Narrāre and the Callable is only executed if there is a match.
#
# Once you have defined all your Commands, they must be added to the 
# the command stack with set_command_stack(in_stack: Array[Command]). 
# This should be done in this script's _ready() function. 
#
# When a command is recieved, Narrāre will go through the
# command_stack in order and check if there is a match to that Command's
# regular expression pattern. If there is a match, it will stop there
# and execute that Command's Callable. Because of this, *the order
# of Commands in the command stack is important.* 
#
# For example, a common command is 'then'. 'then' takes two other commands
# to either side of itself and performs them in sequence, meaning 
# the player can input multiple commands in one step. If 'then' 
# was placed after our previous 'go' command in the command_stack,
# then the input command "go east then go west" would only execute
# 'go east' because it matches the first go command and then stops.
# To get the correct behaviour, we would want to have 'then' before
# 'go' in the command_stack, because in that case 'then' is matched
# first and can then execute the two 'go's correctly.
#
# This script is a global and can be accessed using 'Commands'.
# To parse a command, use 'Commands.parse_command(input_string)'.

var echo_callable: Callable = (
	func(_interactables: InteractablesInterface, matches: RegExMatch) -> String: 
		var out: String = ""
		var echo_phrase: String = matches.get_string("phrase_group");
		if echo_phrase.is_empty():
			out = "Echo what?";
		else:
			out = echo_phrase;
		return out;
		);
var echo_command = Command.new("^echo ?(?'phrase_group'.+)?", echo_callable);

func _ready() -> void:
	set_command_stack([
		echo_command,
		then_command,
		look_command,
		go_command,
		take_command,
		use_command,
		say_command,
		inventory_command,
		save_command,
		load_command,
		help_command,
		quit_command,
	]);
	
const HELP_TEXT: String = (
	"----------------------------[b]HELP[/b]----------------------------\n" 
	+ "In the following list, segments of commands surrounded by\n"
	+ "curly brackets {} are optional. Commands may do different\n"
	 +"things when optional segments are omitted.\n"
	+ "\n"
	+ "Command arguments are surrounded by angle brackets.\n"
	+ "when you want to use a command on something specific,\n"
	+ "you will need to specify what that thing is, either by\n"
	+ "its name or a corresponding number.\n"
	+ "\n"
	+ "---------------------[b]AVAILABLE COMMANDS[/b]---------------------\n"
	+ "- look {at <object name>}\n"
	+ "- take <object name>\n"
	+ "- use <object name> {on <object name>}\n"
	+ "- go <direction>\n"
	+ "- say <something>\n"
	+ "- inventory\n"
	+ "- <command one> then <command two>\n"
	+ "- save {<save name>}\n"
	+ "- load {<save number>}\n"
	+ "- help\n"
	+ "- quit\n"
	+ "------------------------------------------------------------"
);

var then_callable: Callable = (
	func(_interactables: InteractablesInterface, matches: RegExMatch) -> String:
		var out: String = "";
		var command_one = matches.get_string("first_command");
		var command_two = matches.get_string("second_command");
		if !command_one.is_empty() && !command_two.is_empty():
			out += parse_command(command_one);
			out += "\n\n"
			out += parse_command(command_two);
		else:
			out = "'Then' needs two commands.";
		return out;
);
var then_command = Command.new("(?'first_command'.+) then (?'second_command'.+)", then_callable);

var look_callable: Callable = (
	func(interactables: InteractablesInterface, matches: RegExMatch) -> String: 
		var out: String = ""
		var at_object: String = matches.get_string("at_group");
		if at_object.is_empty():
			if matches.get_string("has_at").is_empty():
				out = Narrare.map.get_room_description();
				Narrare.previous_text_displayed = out;
			else:
				out = "Look at what?";
		else:
			var result: Variant = interactables.attempt_interaction(at_object, "look");
			if result == null:
				out = "You're not sure what you're looking at."
			else:
				out = result;
				Narrare.previous_text_displayed = out;
		return out;
		);
var look_command = Command.new("^look(?: (?'has_at'at))?(?: (?'at_group'[\\w ]+))?", look_callable);

var go_callable: Callable = (
	func(_interactables: InteractablesInterface, matches: RegExMatch) -> String:
		var out: String = "";
		var direction_string: String = matches.get_string("direction_group");
		if direction_string.is_empty():
			out = "Go what direction?";
		else:
			var direction: Narrare.Direction = Narrare.Direction.NONE;
			match direction_string:
				"north":
					direction = Narrare.Direction.NORTH;
				"northwest":
					direction = Narrare.Direction.NORTHWEST;
				"west":
					direction = Narrare.Direction.WEST;
				"southwest":
					direction = Narrare.Direction.SOUTHWEST;
				"south":
					direction = Narrare.Direction.SOUTH;
				"southeast":
					direction = Narrare.Direction.SOUTHEAST;
				"east":
					direction = Narrare.Direction.EAST;
				"northeast":
					direction = Narrare.Direction.NORTHEAST;
			var go_result: Variant = Narrare.map.navigate(direction);
			if go_result != null:
				out = go_result;
				Narrare.previous_text_displayed = out;
			else:
				out = "There is no exit in that direction.";
		return out;
		);		
var go_command = Command.new("^go ?(?'direction_group'[\\w]+)?", go_callable);


var take_callable: Callable = (
	func(interactables: InteractablesInterface, matches: RegExMatch) -> String: 
		var out: String = ""
		var take_object: String = matches.get_string("take_group");
		if take_object.is_empty():
			out = "Take what?";
		else:
			var result: Variant = interactables.attempt_interaction(take_object, "take");
			if result == null:
				out = "You're not sure how to take that."
			else:
				out = result;
				Narrare.previous_text_displayed = out;
		return out;
		);
var take_command = Command.new("^take(?: (?'take_group'[\\w ]+))?", take_callable);

var use_callable: Callable = (
	func(interactables: InteractablesInterface, matches: RegExMatch) -> String: 
		var out: String = ""
		var has_on: bool = !matches.get_string("has_on").is_empty();
		if has_on:
			var use_object: String = matches.get_string("use_group");
			var on_object: String = matches.get_string("on_group");
			if on_object.is_empty():
				out = "Use " + use_object + " on what?";
			elif interactables.get_interactable(on_object) == null:
				out = "No '%s' to use that on." % on_object;
			else:
				var result: Variant = interactables.attempt_interaction(use_object, "use", on_object);
				if result == null:
					out = "You're not sure how to use that on that."
				else:
					out = result;
					Narrare.previous_text_displayed = out;
		else:
			var use_single_object: String = matches.get_string("use_single_group");
			if use_single_object.is_empty():
				out = "Use what?";
			else:
				var result: Variant = interactables.attempt_interaction(use_single_object, "use", "");
				if result == null:
					out = "You're not sure how to use that."
				else:
					out = result;
					Narrare.previous_text_displayed = out;
		return out;
		);
		
var use_command = Command.new("^use (?'use_group'[ \\w]+)(?'has_on' on ?)(?'on_group'[ \\w]+)?|use ?(?'use_single_group'[ \\w]+)?", use_callable);

var say_callable: Callable = (
	func(interactables: InteractablesInterface, matches: RegExMatch) -> String:
		var out: String = ""
		var say_phrase: String = matches.get_string("phrase_group");
		if say_phrase.is_empty():
			out = "Say what?";
		else:
			out = "You say, \"%s\".\n\n" % say_phrase;
			var response_flag: bool = false;
			for interactable in interactables.get_all_interactables():
				var result = interactable.attempt_interaction("say", [say_phrase]);
				if result != null:
					out += result + "\n\n";
					response_flag = true;
			if !response_flag:
				out += "No response."
		return out.trim_suffix("\n\n");
		);
var say_command = Command.new("^say ?(?'phrase_group'.+)?", say_callable);

var inventory_callable: Callable = (
	func(_interactables: InteractablesInterface, _matches: RegExMatch) -> String:
		var out = "---------------------[b]INVENTORY[/b]-------------------\n"
		var items = Data.get_inventory();
		if !items.is_empty():
			for item in items:
				out += "- [" + item + "]\n"
		else:
			out += "Your pockets are empty.\n"
		out += "-------------------------------------------------";
		return out;
);
var inventory_command = Command.new("inventory", inventory_callable);

var save_callable: Callable = (
	func(_interactables: InteractablesInterface, matches: RegExMatch) -> String:
		var result: int = -1;
		var save_name: String = matches.get_string("save_name");
		if save_name.is_empty():
			save_name = "-----";
		result = Narrare.save(save_name);
		if result == -1:
			return "Save failed!";
		else:
			return "Saved game as '%s' in slot %d." % [save_name.replace_char('-'.unicode_at(0), ' '.unicode_at(0)), result];
);
var save_command = Command.new("^save ?(?'save_name'[\\w ]+)?", save_callable);

var load_callable: Callable = (
	func(_interactables: InteractablesInterface, matches: RegExMatch) -> String:
		var out: String = "";
		var load_num = matches.get_string("load_number");
		if load_num.is_empty():
			out = Narrare.list_saves();
		else:
			if load_num.is_valid_int():
				if Narrare.data_saved:
					var result_dict: Dictionary = Narrare.load_save(load_num);
					match result_dict.err:
						FAILED:
							out = "There are no saves to load.";
						ERR_INVALID_DATA:
							out = "Something was wrong with that save. It may be malformed or corrupted.";
						OK:
							out = result_dict.out;
				else:
					Narrare.current_prompt = Prompt.new("You have unsaved data which will be lost. Are you sure you want to load this save?")\
						.add_option("Yes, load my game.",(func()-> String:
							var result_dict: Dictionary = Narrare.load_save(load_num);
							var res_out: String = "";
							match result_dict.err:
								FAILED:
									res_out = "There are no saves to load.";
								ERR_INVALID_DATA:
									res_out = "Something was wrong with that save. It may be malformed or corrupted.";
								OK:
									res_out = result_dict.out;
							return res_out;
							))\
						.add_option("No, go back.", (func() -> String: 
							return "Load canceled.";
							));
					out = Narrare.current_prompt.get_display_string();
			else:
				out = "Save number was not a valid integer.";
		return out;
);
var load_command = Command.new("^load ?(?'load_number'[\\w]+)?", load_callable);

var help_callable: Callable = (
	func(_interactables: InteractablesInterface, _matches: RegExMatch) -> String:
		return HELP_TEXT;
);
var help_command = Command.new("^help", help_callable);

var quit_callable: Callable = (
	func(_interactables: InteractablesInterface, _matches: RegExMatch) -> String:
		Narrare.current_prompt = Prompt.new("You have unsaved data which will be lost. Are you sure you want to quit the game?")\
			.add_option("Yes, quit the game.", (func()-> String:
				get_tree().quit();
				return "Quitting.";
				))\
			.add_option("No, go back.", (func() -> String: 
				return "Quit canceled.";
				))
		return Narrare.current_prompt.get_display_string();
);
var quit_command = Command.new("^quit", quit_callable);
