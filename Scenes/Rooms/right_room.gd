extends Room

var lamp = Interactable.new("lamp")\
	.add_interaction("look", (
		func ():
			if Data.lamp_on:
				return "The lamp is on. You can use 'use' to switch it off.";
			else:
				return "The lamp is off. You can use 'use' to switch it on.";
			))\
	.add_interaction("use", (
		func (_used_on: String):
			if Data.lamp_on: 
				Data.lamp_on = false;
				return "You switch the lamp off.";
			else:
				Data.lamp_on = true;
				return "You switch the lamp on.";
			));

var piece_of_paper = Interactable.new("piece of paper")\
	.add_interaction("look", (
		func (): 
			if Data.lamp_unscrewed:
				return "It says, 'Monkeys always look'.";
			else:
				return "No object 'piece of paper' around to look at.";
			));
			
var left_sign = Interactable.new("sign")\
	.add_interaction("look", (
		func (): 
			return "It says, 'Welcome to the Right Room!'"
			));

func _ready() -> void:
	interactables = ["lamp", "piece of paper", "sign"];
	room_interactables.add_interactables([
		lamp,
		piece_of_paper,
		left_sign,
	]);

func look() -> String:
	if Data.lamp_on:
		return "There is a [sign] on the wall. There is a [lamp] on the table. It is switched on. A door to the east leads to the Left Room."
	else:
		return "There is a [sign] on the wall. There is a [lamp] on the table. It is switched off. A door to the east leads to the Left Room.";
