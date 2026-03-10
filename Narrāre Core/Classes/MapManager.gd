extends Node
class_name MapManager

@export var default_map_id: String;
@export var map_dict: Dictionary[String, Resource];

var current_map: Map = null;
var current_map_key: String;

func _ready() -> void:
	Narrare.set_map_manager(self);
	if !default_map_id.is_empty():
		load_map(default_map_id);

func load_map(map_name: String, room_name: Variant = null) -> Error:
	if map_dict.has(map_name):
		for child in get_children():
			child.queue_free();
		var new_map: Map = map_dict[map_name].instantiate();
		add_child(new_map);
		current_map = new_map;
		current_map_key = map_name;
		if room_name is String:
			current_map.set_current_room_by_name(room_name);
		return OK;
	return FAILED;
