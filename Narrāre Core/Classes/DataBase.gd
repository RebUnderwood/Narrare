extends Node
class_name DataBase

func to_dict() -> Dictionary:
	var thisScript: GDScript = get_script();
	var data_dict: Dictionary = {};
	for property_info in thisScript.get_script_property_list():
		if property_info.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			data_dict[property_info.name] = get(property_info.name);
	return data_dict;

func from_dict(in_data_dict: Dictionary) -> void:
	for key in in_data_dict.keys():
		set(key, in_data_dict[key]);
