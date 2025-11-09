extends Node
class_name Room

var exit_north: Exit = null;
var exit_northwest: Exit = null;
var exit_west: Exit = null;
var exit_southwest: Exit = null;
var exit_south: Exit = null;
var exit_southeast: Exit = null;
var exit_east: Exit = null;
var exit_northeast: Exit = null;
var exit_up: Exit = null;
var exit_down: Exit = null;

@export_group("Contents")
@export var room_name: String = "";
@export_multiline var look_description: String = "";
@export_multiline var entry_description: String = "";
@export var interactables: Array[String] = [];

var room_interactables: InteractablesInterface = InteractablesInterface.new();

func _ready() -> void:
	_register_exits();
	
func get_exit_in_direction(direction: Narrare.Direction) -> Exit:
	match direction:
		Narrare.Direction.NORTH:
			return exit_north;
		Narrare.Direction.NORTHWEST:
			return exit_northwest;
		Narrare.Direction.WEST:
			return exit_west;
		Narrare.Direction.SOUTHWEST:
			return exit_southwest;
		Narrare.Direction.SOUTH:
			return exit_south;
		Narrare.Direction.SOUTHEAST:
			return exit_southeast;
		Narrare.Direction.EAST:
			return exit_east;
		Narrare.Direction.NORTHEAST:
			return exit_northeast;
		Narrare.Direction.UP:
			return exit_up;
		Narrare.Direction.DOWN:
			return exit_down;
		_:
			return null;

func look() -> String:
	return look_description;

func describe_entering() -> String:
	var out: String = "[b]%s[/b]\n" % room_name;
	if !entry_description.is_empty():
		out += entry_description + " ";
	out += look();
	return out;
		
func enter_trigger() -> void:
	pass;
	
func exit_trigger() -> void:
	pass;

func _register_exits() -> void:
	for child in get_children():
		if child is Exit:
			child.set_room(self);
			match child.direction:
				Narrare.Direction.NORTH:
					exit_north = child;
				Narrare.Direction.NORTHWEST:
					exit_northwest = child;
				Narrare.Direction.WEST:
					exit_west = child; 
				Narrare.Direction.SOUTHWEST:
					exit_southwest = child;
				Narrare.Direction.SOUTH:
					exit_south = child;
				Narrare.Direction.SOUTHEAST:
					exit_southeast = child;
				Narrare.Direction.EAST:
					exit_east = child;
				Narrare.Direction.NORTHEAST:
					exit_northeast = child;
				Narrare.Direction.UP:
					exit_up = child;
				Narrare.Direction.DOWN:
					exit_down = child;
				_:
					pass;
			
