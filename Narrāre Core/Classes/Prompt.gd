extends Node
class_name Prompt

var question: String = "";
var options: Array[Dictionary] = [];

func _init(in_question: String) -> void:
	question = in_question;
	
func add_option(option_descriptor: String, option_callable: Callable) -> Prompt:
	var new_option: Dictionary = {
		"descriptor": option_descriptor,
		"callable": option_callable,
	}
	options.push_back(new_option);
	return self;
	
func execute_option(selected_option: int) -> Variant:
	if selected_option < options.size():
		return options[selected_option].callable.call();;
	else:
		return null;

func get_display_string() -> String:
	var out: String = "%s\n\n" % question;
	for i in range(options.size()):
		out += "[%d] %s\n" % [i, options[i].descriptor];
	return out;
