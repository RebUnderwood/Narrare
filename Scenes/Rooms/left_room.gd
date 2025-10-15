extends Room

func _ready() -> void:
	interactables = ["screwdriver", "echo"];

func look() -> String:
	if !Data.screwdriver_taken:
		return "There is an echo in here. Sitting on a table in the corner is a [screwdriver]. A door to the west leads to the Right Room."
	else:
		return "There is an echo in here. An empty table sits in the corner. A door to the west leads to the Right Room.";
