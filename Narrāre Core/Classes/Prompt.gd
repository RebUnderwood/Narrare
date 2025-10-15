extends Node
class_name Prompt

var question: String = "";
var options: Array[String] = [];
var callables: Array[Callable] = [];

func _init(in_question: String, in_options: Array[String], in_callables: Array[Callable]) -> void:
	question = in_question;
	options = in_options;
	callables = in_callables;
	
func execute_option(selected_option: int) -> Variant:
	if selected_option < callables.size():
		return callables[selected_option].call();;
	else:
		return null;

func get_display_string() -> String:
	var out: String = "%s\n\n" % question;
	for i in range(options.size()):
		out += "[%d] %s\n" % [i, options[i]];
	return out;
