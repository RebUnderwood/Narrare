extends InteractablesInterface

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
