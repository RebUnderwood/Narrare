# Command Class

Commands are how the player interacts with the game. For example, a common command in many text-based adventure games is some variant of 'go' followed by a cardinal direction, which allows movement between rooms. Commands in Narrāre take the form of [Command](command.md) objects, which must be added to the command stack in the [Commands](commands.md) script.

Commands have essentially two components: a Regular Expression pattern, which is used to match the command against user input, and a callable, which is what is executed when the Command is matched.

## Constructing a Command
You can construct a new Command using `Command.new(regex_string: String, in_callable: Callable)`. Here's an example, a Command for 'echo' that returns whatever the player said:

```gdscript
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
```

Note that the callable has a very specific function signature. It should take two arguments: an [InteractablesInterface](interactablesinterface.md) and a [RegExMatch](https://docs.godotengine.org/en/stable/classes/class_regexmatch.html). The [InteractablesInterface](interactablesinterface.md) will contain all of the [Interactables](interactables.md) that are available to the player, both from the current [Room](room.md) and the player's inventory (see [Data](data.md)). The [RegExMatch](https://docs.godotengine.org/en/stable/classes/class_regexmatch.html) will contain any matching groups from the Command's pattern; this is where you'll be able to access any arguments the player supplied.

Additionally, the callable should return a `String`. This string is what will be presented to the player as the result of executing the command they inputted. In our above 'echo' example, if the player typed 'echo Hello world!' then the returned value from the callable is "hello world!" (commands are lowercased as part of the process of matching) and so this is what will be shown to the player using [`Narrare.say`](narrare_global_script.md#say).

---

## Functions

##### attempt_match_execute

> **`attempt_match_execute(input_string: String, interactables: InteractablesInterface) -> Variant`**

> Attempts to match `input_string` against the Command's Regular Expression pattern. If the pattern matches, the Command will be executed and the callable will be called, returning its result. If the pattern does not match the input, then `null` is returned.