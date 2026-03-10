extends Room

var lamp = Interactable.new("lamp")\
	.add_synonyms("light", "desk lamp", "lamp base", "lamp's base", "base of the lamp")\
	.add_interaction("look", (
		func():
			if Data.lamp_on:
				return "The |lamp| is on. The bottom of the |lamp| is held on by screws.";
			else:
				return "The |lamp| is off. The bottom of the |lamp| is held on by screws.";
			))\
	.add_interaction("use", (
		func (used_with: String) -> String: 
			match used_with:
				"screwdriver":
					if !Data.lamp_unscrewed:
						Data.lamp_unscrewed = true;
						return "You unscrew the base of the |lamp| using the |screwdriver|.\nInside is a |piece of paper|.";
					else:
						return "You already unscrewed the |lamp|.";
				"":
					if Data.lamp_on: 
						Data.lamp_on = false;
						set_state("lamp_off");
						return "You switch the |lamp| off.";
					else:
						Data.lamp_on = true;
						set_state("lamp_on");
						return "You switch the |lamp| on.";
				_:
					return "You're not sure how to use the |lamp| with that.'";
			))\
		.add_command(Command.new("switch on", "^((?:(?:turn|switch) on?(?: the)?(?: lamp| light| desk lamp))|(?:(?:turn|switch)(?: the)?(?: lamp| light| desk lamp) on))$", (
			func(_interactables: InteractablesInterface, _matches: RegExMatch) -> String:
				if !Data.lamp_on: 
					Data.lamp_on = true;
					set_state("lamp_on");
					return "You switch the |lamp| on.";
				else:
					return "The |lamp| is already on!";
				)))\
		.add_command(Command.new("switch off", "^((?:(?:turn|switch) off?(?: the)?(?: lamp| light| desk lamp))|(?:(?:turn|switch)(?: the)?(?: lamp| light| desk lamp) off))$", (
			func(_interactables: InteractablesInterface, _matches: RegExMatch) -> String:
				if Data.lamp_on: 
					Data.lamp_on = false;
					set_state("lamp_off");
					return "You switch the |lamp| off.";
				else:
					return "The |lamp| is already off!";
				)))\
		.add_interaction("unscrew", (
			func() -> String:
				if !Data.lamp_unscrewed:
					Data.lamp_unscrewed = true;
					return "You unscrew the base of the |lamp| using the |screwdriver|.\nInside is a |piece of paper|.";
				else:
					return "You already unscrewed the |lamp|.";
				))\
		.add_interaction("screw", (
			func() -> String:
				if Data.lamp_unscrewed:
					Data.lamp_unscrewed = false;
					return "You put the base of the |lamp| back on and screw it into place.";
				else:
					return "The base of the |lamp| is firmly screwed on already. Don't want to strip the screws!";
				));

var piece_of_paper = Interactable.new("piece of paper")\
	.add_synonyms("note")\
	.is_revealed_by("lamp_unscrewed")\
	.add_basic_interaction("look", "It says, 'Monkeys always look'.")\
	.add_interaction_synonym("read", "look");

var wall_sign = Interactable.new("sign")\
	.add_basic_interaction("look", "It says, 'Welcome to the Right Room!'")\
	.add_interaction_synonym("read", "look");

func _ready() -> void:
	add_state("lamp_off")\
		.set_look_description("There is a |sign| on the wall. There is a |lamp| on the table. It is switched off. A door to the west leads to the Left Room.")\
		.add_interactables(
			lamp,
			piece_of_paper,
			wall_sign,
		);
	super(); # We put the super call *after* the initial state is defined when using an initial state.
	add_state("lamp_on")\
		.set_look_description("There is a |sign| on the wall. There is a |lamp| on the table. It is switched on. A door to the west leads to the Left Room.")\
		.add_interactables(
			lamp,
			piece_of_paper,
			wall_sign,
		);
	if Data.lamp_on:
		set_state("lamp_on");
