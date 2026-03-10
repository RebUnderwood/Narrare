extends TextTransformersBase

var highlight_regex = RegEx.create_from_string("\\|(?'to_highlight'.+?)\\|");
func highlight_interactables(in_string: String) -> String:
	var out_string = in_string;
	for h_match in highlight_regex.search_all(in_string):
		var h_name: String = h_match.get_string("to_highlight");
		out_string = out_string.replace("|" + h_name + "|", "[color=gold]" + h_name + "[/color]");
	return out_string;

func _ready() -> void:
	register_transformers(
		highlight_interactables,
	);
	
