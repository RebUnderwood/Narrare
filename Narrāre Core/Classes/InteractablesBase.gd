extends InteractablesInterface
class_name InteractablesBase

var _global_interactables: Array[String] = [];

func add_global_interactable(interactable_identifier: String) -> Array[String]:
	_global_interactables.push_back(interactable_identifier);
	return _global_interactables;

func remove_global_interactable(interactable_identifier: String) -> Array[String]:
	_global_interactables.erase(interactable_identifier);
	return _global_interactables;
	
func set_global_interactables(interactables: Array[String]) -> void:
	_global_interactables = interactables;

func get_global_interactables() -> Array[String]:
	return _global_interactables;
