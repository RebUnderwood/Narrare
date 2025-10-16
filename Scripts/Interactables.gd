extends InteractablesInterface

# === INTERACTABLES ===
# The Dictionary variable objs is used to store all of your game's
# interactables. Interactables are anything in your game that can be
# interacted with. This includes things like takeable items, things
# in a Room that can be looked at in more detail, people that can
# be conversed with, etc. If you can use a command on it, it's an
# interactable.
#
# Interactables should themselves be dictionaries. The name of the
# key in objs should be identical to the name of the interactable
# as it appears in game, i.e. if you have an interactable [deck of cards]
# it should appear in objs as "deck of cards": {}.
#
# Interaction methods can be defined as entries in the interactable's
# Dictionary as Callables. These Callables must always return a string;
# this string is what gets shown to the player.
#
# When a command is executed, it should get the relevant callable 
# and execute it. For example, if I had a command 'shuffle', and
# it is used on [deck of cards], the shuffle command should find
# a corresponding 'shuffle' entry in the 'deck of cards' entry in
# objs and execute that Callable. More on commands can be found 
# in the Commands.gd script.
#
# This script is a global, and can be accessed with 'Interactables'.
# However, you should never need to interact with objs directly;
# instead, you should get interactables by name using 
# Interactables.get_interactable("interactable name"). Because
# interactables are accessed by name, you should ensure that no two
# interactables have the same name.
#
# You should overwrite objs in this script's _ready() function.

var screwdriver = Interactable.new("screwdriver")\
	.add_interaction("look", func () -> String: return "It's a plain phillips head screwdriver.")\
	.add_interaction("use", (
		func (used_on: String) -> String: 
			match used_on:
				"lamp":
					if !Data.lamp_unscrewed:
						Data.lamp_unscrewed = true;
						return "You unscrew the base of the [lamp] using the [screwdriver].\nInside was a [piece of paper].";
					else:
						return "You already unscrewed the [lamp].";
				"":
					return "The [screwdriver] needs to be used on something.";
				_:
					return "You're not sure how to use a [screwdriver] on that.'";
					
			))\
	.add_interaction("take", (
		func() -> String:
			if !Data.screwdriver_taken:
				Data.screwdriver_taken = true;
				Narrare.add_to_inventory("screwdriver");
				return "You pick up the [screwdriver] and slip it into your pocket.";
			else:
				return "You already took the screwdriver.";
			));



func _ready() -> void:
	add_interactables([
		screwdriver,
	]);
