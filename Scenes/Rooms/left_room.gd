extends Room

var echo = Interactable.new("echo")\
	.add_interaction("say", (
		func(phrase: String) -> String: 
			if phrase.to_lower() == "echo":
				return "The echo says, \"Hey, that's me!\"";
			return "The echo says, \"%s\"." % phrase;
			));
			
var right_sign = Interactable.new("sign")\
	.add_basic_interaction("look", "It says, 'Welcome to the Left Room!'");

func _ready() -> void:
	super();
	interactables = ["screwdriver", "echo", "sign"];
	room_interactables.add_interactables([
		echo, 
		right_sign,
	]);

func look() -> String:
	if !Data.screwdriver_taken:
		return "There is an echo in here. There is a [sign] on the wall. Sitting on a table in the corner is a [screwdriver]. A door to the east leads to the Right Room."
	else:
		return "There is an echo in here. There is a [sign] on the wall. An empty table sits in the corner. A door to the east leads to the Right Room.";
