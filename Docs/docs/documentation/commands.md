# Commands Script
The Commands script (Scripts/Commands.gd) is used to define and register your game's commands. Commands are how the player interacts with the game. For example, a common command in many text-based adventure games is some variant of 'go' followed by a cardinal direction, which allows movement between rooms. A number of example commands have been included in this file in the template; feel free to add, remove, or modify them as needed!

Commands in Narrāre take the form of [Command](command.md) objects, which are stored in this script's command stack. The command stack is an `Array` of [Command](command.md)s that, when [`Commands.parse_command`](commandsbase.md#parse_command) is called, are iterated through in an attempt to match the input from the player against each [Command](command.md)'s pattern. When a match is found, `parse_command` stops and that [Command](command.md) is executed.

Because of this, *the order of [Command](command.md)s in the command stack is important.* For example, a common command is 'then'. 'then' takes two other commands to either side of itself and performs them in sequence, meaning the player can input multiple commands in one step. If 'then' was placed after our previous 'go' command in the command stack then the input command "go east then go west" would only execute 'go east' because it matches the first go command and then stops. To get the correct behaviour, we would want to have 'then' before 'go' in the command stack, because in that case 'then' is matched first and can then execute the two 'go's correctly.

This script is global and can be accessed using `Commands`. More information about its methods can be found in the documentation for the [CommandsBase](commandsbase.md) class, which this script extends.

## Tutorial

Let's look at how to add commands. First, we'll crreate two [Command](command.md)s: 'look' and 'take':

``` gdscript
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
```

Now, we can set the command stack. This is done in the Commands script's `_ready()` function like so:

```gdscript
func _ready() -> void:
	set_command_stack([
		look_command,
		take_command,
	]);
```

And that's it! Now, if we were to call [`Commands.parse_command`](commandsbase.md#parse_command) like so:

```gdscript
Commands.parse_command("look at box");
```

[`Commands.parse_command`](commandsbase.md#parse_command) will match the 'look' [Command](command.md)'s pattern and execute it. Note again that because 'look' comes before 'take' in the command stack, Narrāre will attempt to match to the 'look' command before it tries to match to the 'take' command. Keep this in mind When setting up your stack!
