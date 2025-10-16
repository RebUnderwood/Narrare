extends Node
class_name Room

@export_group("Exits")
@export var exit_north: Room = null;
@export var exit_northwest: Room = null;
@export var exit_west: Room = null;
@export var exit_southwest: Room = null;
@export var exit_south: Room = null;
@export var exit_southeast: Room = null;
@export var exit_east: Room = null;
@export var exit_northeast: Room = null;
@export var exit_up: Room = null;
@export var exit_down: Room = null;

@export_group("Entrance Text")
@export var enter_north_text: String = "";
@export var enter_northwest_text: String = "";
@export var enter_west_text: String = "";
@export var enter_southwest_text: String = "";
@export var enter_south_text: String = "";
@export var enter_southeast_text: String = "";
@export var enter_east_text: String = "";
@export var enter_northeast_text: String = "";
@export var entry_description: String = "";

@export_group("Contents")
@export var room_name: String = "";
@export var look_description: String = "";
@export var interactables: Array[String] = [];

var room_interactables: InteractablesInterface = InteractablesInterface.new();

func get_room_in_direction(direction: Narrare.Direction) -> Room:
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

func enter(from: Room) -> String:
	var out: String = "[b]%s[/b]\n" % room_name;
	match from:
		exit_north:
			out += enter_north_text + " ";
		exit_northwest:
			out += enter_northwest_text + " ";
		exit_west:
			out += enter_west_text + " ";
		exit_southwest:
			out += enter_southwest_text + " ";
		exit_south:
			out += enter_south_text + " ";
		exit_southeast:
			out += enter_southeast_text + " ";
		exit_east:
			out += enter_east_text + " ";
		exit_northeast:
			out += enter_northeast_text + " ";
	if !entry_description.is_empty():
		out += entry_description + " ";
	out += look();
	return out;
		
func enter_trigger() -> void:
	pass;
	
func exit_trigger() -> void:
	pass;
