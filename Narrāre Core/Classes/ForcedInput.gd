extends InputRequest
class_name ForcedInput

var forced_input: String = "";

func _replace_text(in_input_text: String) -> void:
	var input_length = in_input_text.length();
	Narrare.say_to_input(forced_input.substr(0,input_length));
	
func _init(in_question: String, forced_text: String, in_callable: Callable) -> void:
	question = in_question;
	callable = in_callable;
	forced_input = forced_text;
	Narrare.input_text_changed.connect(_replace_text);
