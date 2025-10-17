extends Control

@onready var interface = $Interface;
@onready var map = $Map;

@export var fullscreen = false

func _ready() -> void:
	Narrare.say_something.connect(_on_something_says);
	Narrare.clear_output.connect(_on_clear_requested);
	var name_input_request_question: String = "Enter your name:";
	var name_input_request_callable: Callable = (
		func(in_input) -> String:
			Data.player_name = in_input;
			var out: String = "Welcome %s!\n\n%s" % [Data.player_name, Narrare.map.get_room_description()];
			Narrare.previous_text_displayed = out;
			return out;
			);
	Narrare.current_input_request = InputRequest.new(name_input_request_question, name_input_request_callable);
	_write_to_interface(Narrare.current_input_request.get_display_string());

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		fullscreen = !fullscreen;
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	
func _write_to_interface(message: String) -> void:
	interface.display_text(message);
	
func _clear_interface() -> void:
	interface.clear_text();

func _parse_command(command: String) -> void:
	var output: String = Commands.parse_command(command);
	_write_to_interface(output);

# === Signals ===
func _on_something_says(message: String) -> void:
	_write_to_interface(message);
	
func _on_clear_requested() -> void:
	_clear_interface();
	
func _on_interface_command_inputted(command: String) -> void:
	_parse_command(command);
