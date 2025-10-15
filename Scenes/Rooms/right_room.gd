extends Room

func _ready() -> void:
	interactables = ["lamp", "piece of paper"];

func look() -> String:
	if Data.lamp_on:
		return "There is a [lamp] on the table. It is switched on. A door to the east leads to the Left Room."
	else:
		return "There is a [lamp] on the table. It is switched off. A door to the east leads to the Left Room.";
