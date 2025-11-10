extends Room

var lamp = Interactable.new("lamp")\
	.add_synonyms("light", "desk lamp")\
	.add_interaction("look", (
		func ():
			if Data.lamp_on:
				return "The lamp is on. You can use 'use' to switch it off. The bottom of the lamp is held on by screws.";
			else:
				return "The lamp is off. You can use 'use' to switch it on. The bottom of the lamp is held on by screws.";
			))\
	.add_interaction("use", (
		func (used_with: String) -> String: 
			match used_with:
				"screwdriver":
					if !Data.lamp_unscrewed:
						Data.lamp_unscrewed = true;
						return "You unscrew the base of the [lamp] using the [screwdriver].\nInside was a [piece of paper].";
					else:
						return "You already unscrewed the [lamp].";
				"":
					if Data.lamp_on: 
						Data.lamp_on = false;
						return "You switch the lamp off.";
					else:
						Data.lamp_on = true;
						return "You switch the lamp on.";
				_:
					return "You're not sure how to use the [lamp] with that.'";
					
			));

var piece_of_paper = Interactable.new("piece of paper")\
	.add_basic_interaction("look", "It says, 'Monkeys always look'.")\
	.is_revealed_by("lamp_unscrewed")
			
var left_sign = Interactable.new("sign")\
	.add_basic_interaction("look", "It says, 'Welcome to the Right Room!'");

func _ready() -> void:
	super();
	interactables = ["lamp", "piece of paper", "sign"];
	room_interactables.add_interactables([
		lamp,
		piece_of_paper,
		left_sign,
	]);

func look() -> String:
	if Data.lamp_on:
		return "There is a [sign] on the wall. There is a [lamp] on the table. It is switched on. A door to the west leads to the Left Room."
	else:
		return "There is a [sign] on the wall. There is a [lamp] on the table. It is switched off. A door to the west leads to the Left Room.";
