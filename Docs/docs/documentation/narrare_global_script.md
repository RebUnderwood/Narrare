# Narrare
The Narrare global script contains variables, enums, signals, and functions used throughout a Narrāre game. It can be accessed with `Narrare` from anywhere in the project. For example:

```godot
Narrare.say("Hello world!");
```

---

## Enums


##### Direction  
> **`Direction {NONE, NORTH, NORTHWEST, WEST, SOUTHWEST, SOUTH, SOUTHEAST, EAST, NORTHEAST, UP, DOWN}`**

> Indicates a cardinal direction, as well as up or down. Typically used to refer to an exit or entrance to a Room.

---

## Signals

These signals can be connected to from anywhere in the project.

##### say_something

> **`say_something(message: String)`**

>Indicates that a String 'message' should be outputted to the player. This will typically be connected to by the interface, but could be used for other purposes as well.

##### clear_output

> **`clear_output`**

>Indicates that the output should be cleared.

##### done_writing_to_output
> **`done_writing_to_output`**

>This should be emitted when the interface is done writing something to the output. You do not need to do this if you will not be using this signal.

##### done_writing_to_input
> **`done_writing_to_input`**

> This should be emitted when the interface is done writing something to the command input. You do not need to do this if you will not be using this signal.

##### prompt_changed
> **`prompt_changed(is_prompt: bool)`**

> Emitted when a change is made to the Narrare.current_prompt variable; if Narrare.current_prompt has been set to null, is_prompt will be false, otherwise it will be true.

##### input_request_changed
> **`input_request_changed(is_input_request: bool)`**

> Emitted when a change is made to the Narrare.current_input_request variable; if Narrare.current_input_request has been set to null, is_input_request will be false, otherwise it will be true.

---

## Variables

##### map

> **`map: Map`**

>The current Map. This should be set by the game when a Map node is loaded.

##### previous_text_displayed

> **`previous_text_displayed: String`**

> The last meaningful text to be output to the player. This text is saved when calling `Narrare.save()`, and will be output when that save is loaded. It is generally advised that you only set this variable when something useful is output, like the description of a room or the result of interacting with an interactable.

##### data_saved

> **`data_saved: bool`**

> Should be set to `true` only if the game state has not been changed since the last time the game was saved. If it is `false`, a confirmation prompt will be shown when loading a save. Generally you won't have to interact with this variable yourself.

##### current_prompt

> **`current_prompt: Prompt`**

> If you want to present the player with a [Prompt](prompt.md), this variable should be set to that Prompt. Otherwise, it should be null. Changing this variable emits the `prompt_changed` signal.

##### current_input_request

> `current_input_request: InputRequest`**  

> If you want to present the player with an [InputRequest](inputrequest.md), this variable should be set to that InputRequest. Otherwise, it should be null. Changing this variable emits the `input_request_changed` signal.

---

## Functions

##### say

> **`say(message: String) -> void`**

> A convenience function. Emits the `say_something(message)` signal, indicating that `message` should be output to the player.

##### clear

> **`clear() -> void`**

> A convenience function. Emits the `clear_output` signal, indicating that the output should be cleared.

##### save

> **`save(save_name: String = "-----") -> int`**

> Attempts to save the game. Saves are saved to the `user://Saves` directory. Saves are given a name `save_name` which will be displayed when calling `Narrare.list_saves()`. The returned int is the number of the save which will be used to access it by `Narrare.load_save(save_number: String)`. It will return -1 if the save failed.

##### list_saves

> **`list_saves() -> String`**

> Returns in String format a list of saves in the `user://Saves` directory.

##### load_save

> **`load_save(save_number: String) -> Dictionary`**
> Attempts to load a saved game from the `user://Saves` directory by save_number. Note that save_number is given as a String; this is because this will be user input. If this function succeeds, the game state will be changed to reflect the data in the loaded save. Returns a Dictionary of the form `{"err": Error, "out": String}` where err is a Godot Error enum value and out is a resulting string to output to the user. If `Narrare.data_saved` is `false`, a confirmation Prompt will be given to the user before the load goes through.