extends Node
class_name InteractablesBase

var objs: Dictionary = {}
	
func get_interactable(object_name: String) -> Variant:
	if !objs.has(object_name):
		return null;
	else:
		return objs[object_name]
