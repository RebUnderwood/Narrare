extends PanelContainer

signal command_inputted(command: String);

@onready var text_output = $VBoxContainer/TextOutput;
@onready var command_input = $VBoxContainer/CommandInput;

@export var use_typewriter_effect: bool = true;
@export var command_history_max_length: int = 15;
@export var input_placeholder_text: String = "Type 'help' for a list of commands.";

var text_tweener: Tween = null;
var command_history: Array[String] = [];
var command_history_index: int = -1;

func _ready() -> void:
	Narrare.prompt_changed.connect(_on_prompt_changed);
	Narrare.input_request_changed.connect(_on_input_request_changed);
	command_input.placeholder_text = input_placeholder_text;
	_focus_command_input();
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("previous_command_in_history"):
		_load_command_in_history(1);
	elif Input.is_action_just_pressed("next_command_in_history"):
		_load_command_in_history(-1);
			
func display_text(message: String, typewriter_effect: bool = true, speed_scale: float = 1.0) -> void:
	message += "\n\n";
	text_output.text += message;
	if use_typewriter_effect && typewriter_effect:
		var target_len: int = text_output.get_parsed_text().length();
		if text_tweener:
			text_tweener.kill();
		text_tweener = create_tween();
		text_tweener.tween_property(text_output, "visible_characters", target_len, .005 * (target_len - text_output.visible_characters) * speed_scale);
		text_tweener.tween_callback(func() -> void: Narrare.done_writing_to_output.emit());
	else:
		text_output.visible_characters = -1;
		Narrare.done_writing_to_output.emit();

func get_text() -> String:
	return text_output.text;
	
func clear_text() -> void:
	text_output.clear();
	
func write_to_input(message: String, typewriter_effect: bool = false, speed_scale: float = 1.0) -> void:
	command_input.text = "";
	if use_typewriter_effect && typewriter_effect:
		command_input.caret_blink = false;
		_add_char_to_input(0, message.split(), speed_scale);
	else:
		command_input.text = message;
		command_input.caret_column = command_input.text.length();
		
func add_command_to_history(in_command: String) -> void:
	command_history.push_front(in_command);
	if command_history.size() - 1 > command_history_max_length:
		command_history.pop_back();

func _add_char_to_input(index: int, in_arr: PackedStringArray, speed_scale: float) -> void:
	var new_text: String = "".join(in_arr.slice(0, index + 1));
	command_input.text = new_text;
	command_input.caret_column = command_input.text.length();
	if index >= in_arr.size() - 1:
		print(index)
		Narrare.done_writing_to_input.emit();
		command_input.caret_blink = true;
	else:
		get_tree().create_timer(.005 * speed_scale).timeout.connect(_add_char_to_input.bind(index + 1, in_arr, speed_scale));

func _load_command_in_history(index_modifier: int) -> void:
	command_history_index += index_modifier;
	if command_history_index < 0:
		command_history_index = -1;
	elif command_history_index >= command_history.size() - 1:
		command_history_index = command_history.size() - 1;
	if command_history_index == -1:
		command_input.clear();
		_focus_command_input();
	else:
		write_to_input(command_history[command_history_index], false);

func _focus_command_input() -> void:
	command_input.grab_focus.call_deferred();
	
# === SIGNALS ===
func _on_command_input_text_submitted(new_text: String) -> void:
	command_history_index = -1;
	add_command_to_history(new_text);
	command_inputted.emit(new_text);
	command_input.clear();
	_focus_command_input();
	
func _on_prompt_changed(is_prompt: bool) -> void:
	if is_prompt:
		command_input.placeholder_text = "Enter the number of the option you want to select.";
	else:
		command_input.placeholder_text = input_placeholder_text;

func _on_input_request_changed(is_input_request: bool) -> void:
	if is_input_request:
		command_input.placeholder_text = "Type your answer.";
	else:
		command_input.placeholder_text = input_placeholder_text;
