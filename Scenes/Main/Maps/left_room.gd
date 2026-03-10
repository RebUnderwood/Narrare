extends Room

enum States {SCREWDRIVER_TAKEN}

var echo = Interactable.new("echo")\
	.add_interaction("say", (
		func(phrase: String) -> String: 
			if phrase.to_lower().similarity("echo") >= .8:
				return "The echo says, \"Hey, that's me!\"";
			return "The echo says, \"%s\"." % phrase;
			));

var wall_sign = Interactable.new("sign")\
	.add_basic_interaction("look", "It says, 'Welcome to the Left Room!'")\
	.add_interaction_synonym("read", "look");

func _ready() -> void:
	super();
	add_interactables(
		"screwdriver",
		echo,
		wall_sign,
	);
	add_state("screwdriver_taken")\
		.set_look_description("There is an echo in here. There is a |sign| on the wall. An empty table sits in the corner. A door to the east leads to the Right Room.")\
		.add_interactables(
			echo,
			wall_sign,
		);
	if Data.screwdriver_taken:
		set_state("screwdriver_taken");
