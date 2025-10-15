extends Node
class_name InputRequest

var question: String = "";
var callable: Callable = func(_in_input: String) -> String: return _in_input;

func _init(in_question: String, in_callable: Callable) -> void:
	question = in_question;
	callable = in_callable;
	
func execute_callable(in_input: String) -> String:
	return callable.call(in_input);
	
func get_display_string() -> String:
	return question;
