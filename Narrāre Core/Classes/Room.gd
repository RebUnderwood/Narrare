extends Node
class_name Room

@export var room_name: String = "";
@export_multiline var look_description: String = "";
@export_multiline var entry_description: String = "";
@export var initial_state: String = "";

var current_state: Variant = null;
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
var room_states: Dictionary[Variant, RoomState] = {
	null: RoomState.new()
}

func _ready() -> void:
	_register_exits();
	if !initial_state.is_empty():
		current_state = initial_state;
	var s = null; #I don't know why this is neccessary, Godot throws an error if you index a null on a dictionary but it *does* work, so... workaround.
	room_states[s]\
		.set_look_description(look_description)\
		.set_entry_description(entry_description)
	
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
	return get_current_state().look_description;

func describe_entering() -> String:
	var out: String = "[b]%s[/b]\n" % room_name;
	if !get_current_state().entry_description.is_empty():
		out += get_current_state().entry_description + " ";
	out += look();
	return out;

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

func get_current_state() -> RoomState:
	return room_states[current_state];
	
func add_state(state_identifier: Variant) -> RoomState:
	room_states[state_identifier] = RoomState.new();
	return room_states[state_identifier];
	
func get_state(state_identifier: Variant) -> RoomState:
	return room_states[state_identifier];
	
func set_current_state(state_identifier: Variant) -> void:
	current_state = state_identifier;

func add_interactables(...in_interactables: Array) -> void:
	get_current_state().add_interactables.callv(in_interactables);

func add_enter_trigger(trigger: Callable) -> void:
	get_current_state().add_enter_trigger(trigger);

func add_exit_trigger(trigger: Callable) -> void:
	get_current_state().add_exit_trigger(trigger);
	
func enter_trigger() -> void:
	get_current_state().enter_trigger()
	
func exit_trigger() -> void:
	get_current_state().exit_trigger()
	
	
	
	
