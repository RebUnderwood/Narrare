extends InteractablesBase

# === INTERACTABLES ===
#
# This script should be used to house any Interactables that 
# need to be accessed across rooms, i.e. Interactables that 
# are in multiple rooms or Interactables that can be added to
# the player's inventory. For Room-specific Interactables, 
# use that room's room_interactables property.
#
# Interactables should be Interactable objects constructed with 
# Interactable.new(<identifier>). See the Interactable class for
# more info. You can add an array of Interactables to this script 
# using add_interactables([<my_interactables>]), or individual
# Interactables using add_interactable(<my_interactable>).
#
# To retrieve Interactables from this script from anywhere in 
# the project, you can use Interactables.get_interactable(<identifier>).
# To retrieve an array of all the Interactables, you can use
# Interactables.get_all_interactables().
#
# Interactables in this script will override Interactables with
# the same identifier in a Room's room_interactables property.
#
# Interactables should be given identifiers that match the name
# of the object shown to the player, i.e. what they should type
# into the console to interact with that Interactable. Additionally,
# and this is *very* important, ALL INTERACTABLES IN THIS FILE
# (or in an individual Room's room_interactables property) MUST
# HAVE UNIQUE IDENTIFIERS. If they do not, the earlier Interactable
# will be overwritten.

var screwdriver = Interactable.new("screwdriver")\
	.add_synonyms("phillips-head", "phillips head", "phillips head screwdriver","phillips-head screwdriver")\
	.add_basic_interaction("look", "It's a plain phillips head |screwdriver|.")\
	.add_interaction("take", (
		func() -> String:
			if !Data.screwdriver_taken:
				Data.screwdriver_taken = true;
				Data.add_to_inventory("screwdriver");
				Narrare.map.get_current_room().set_current_state("screwdriver_taken");
				return "You pick up the |screwdriver| and slip it into your pocket.";
			else:
				return "You already took the |screwdriver|.";
			))\
	.add_command(Command.new("unscrew", "^unscrew(?:(?: (?:the))? (?'unscrew_group'.+))?", (
		func(interactables: InteractablesInterface, matches: RegExMatch) -> String:
			var out: String = ""
			var unscrew_object: String = matches.get_string("unscrew_group");
			if unscrew_object.is_empty():
				out = "Unscrew what?";
			else:
				var result: Variant = interactables.attempt_interaction(unscrew_object, "unscrew");
				if result == null:
					out = "You're not sure how to unscrew that exactly."
				else:
					out = result;
					Narrare.previous_text_displayed = out;
			return out;
			)))\
	.add_command(Command.new("screw in", "^screw(?: in)?(?:(?: (?:the))? (?'screw_group'.+))?", (
		func(interactables: InteractablesInterface, matches: RegExMatch) -> String:
			var out: String = ""
			var screw_object: String = matches.get_string("screw_group");
			if screw_object.is_empty():
				out = "Screw in what?";
			else:
				var result: Variant = interactables.attempt_interaction(screw_object, "screw");
				if result == null:
					out = "You're not sure how to screw that in exactly."
				else:
					out = result;
					Narrare.previous_text_displayed = out;
			return out;
			)))

func _ready() -> void:
	add_interactables([
		screwdriver,
	]);
