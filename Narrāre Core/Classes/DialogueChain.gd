extends Node
class_name DialogueChain

var _dialogue_dict: Dictionary[String, Callable] = {}

func get_statement(identifier: Variant) -> Callable:
	if identifier is String:
		return _dialogue_dict[identifier];
	else:
		return func() -> void: pass;
	
func run_statement(identifier: Variant, ...args: Array) -> Variant:
	if identifier is String:
		return _dialogue_dict[identifier].callv(args);
	else:
		return "";

func get_start() -> Callable:
	return get_statement("_start_");
	
func start() -> Variant:
	return run_statement("_start_");

func add_basic_statement(identifier: String, dialogue: String, points_to: Variant = null) -> DialogueChain:
	_dialogue_dict[identifier] = func (_a = null) -> String: return dialogue + run_statement(points_to);
	return self;

func add_start_basic_statement(dialogue: String, points_to: Variant = null) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func (_a = null) -> String: 
			return dialogue + "\n\n" + run_statement(points_to);
			);
	return self;
	
func add_custom_statement(identifier: String, callable: Callable, points_to: Variant = null) -> DialogueChain:
	_dialogue_dict[identifier] = func(...a: Array) -> String:
		if points_to is String:
			return callable.callv(a) + run_statement(points_to);
		else:
			return callable.callv(a);
	return self;
	
func add_start_forced_input_statement(dialogue: String, forced_input: String, points_to: Variant = null) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func(_a = null) -> String:
			var new_forced_input = ForcedInput.new(dialogue, forced_input, get_statement(points_to));
			Narrare.current_input_request = new_forced_input;
			return Narrare.current_input_request.get_display_string();
			);
	return self;
	
func add_forced_input_statement(identifier: String, dialogue: String, forced_input: String, points_to: Variant = null) -> DialogueChain:
	_dialogue_dict[identifier] = (
		func(_a = null) -> String:
			var new_forced_input = ForcedInput.new(dialogue, forced_input, get_statement(points_to));
			Narrare.current_input_request = new_forced_input;
			return Narrare.current_input_request.get_display_string();
			);
	return self;

func add_prompt_statement(identifier: String, dialogue: String, options: Array[Dictionary]) -> DialogueChain:
	_dialogue_dict[identifier] = (
		func(_a = null) -> String:
			var new_prompt: Prompt = Prompt.new(dialogue);
			for opt_dict in options:
				new_prompt.add_option(opt_dict.description, opt_dict.callable);
			Narrare.current_prompt = new_prompt;
			return Narrare.current_prompt.get_display_string();
			);
	return self;

func add_start_prompt_statement(dialogue: String, options: Array[Dictionary]) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func(_a = null) -> String:
			var new_prompt: Prompt = Prompt.new(dialogue);
			for opt_dict in options:
				new_prompt.add_option(opt_dict.description, opt_dict.callable);
			Narrare.current_prompt = new_prompt;
			return Narrare.current_prompt.get_display_string();
			);
	return self;
	
func add_input_request_statement(identifier: String, dialogue: String, callback: Callable, points_to = null) -> DialogueChain:
	_dialogue_dict[identifier] = (
		func(_a = null) -> String:
			var wrapped_callback: Callable = func(input: String) -> String:
				callback.call(input);
				return run_statement(points_to);
			var new_input_request: InputRequest = InputRequest.new(dialogue, wrapped_callback);
			Narrare.current_input_request = new_input_request;
			return Narrare.current_input_request.get_display_string();
	)
	return self;
	
func add_start_input_request_statement(dialogue: String, callback: Callable, points_to = null) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func(_a = null) -> String:
			var wrapped_callback: Callable = func(input: String) -> String:
				callback.call(input);
				return run_statement(points_to);
			var new_input_request: InputRequest = InputRequest.new(dialogue, wrapped_callback);
			Narrare.current_input_request = new_input_request;
			return Narrare.current_input_request.get_display_string();
	)
	return self;
	
func add_start_input_request_set_flag_statement(dialogue: String, callback: Callable, points_to = null) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func(_a = null) -> String:
			var wrapped_callback: Callable = func(input: String) -> String:
				callback.call(input);
				return run_statement(points_to);
			var new_input_request: InputRequest = InputRequest.new(dialogue, wrapped_callback);
			Narrare.current_input_request = new_input_request;
			return Narrare.current_input_request.get_display_string();
	)
	return self;

func add_data_branch_condition(identifier: String, data_branch_condition: String, go_to_on_true: String, go_to_on_false: String) -> DialogueChain:
	_dialogue_dict[identifier] = (
		func(_a = null) -> String:
			var branch_condition = Data.get(data_branch_condition)
			var next_ident = go_to_on_true;
			if !branch_condition:
				next_ident = go_to_on_false;
			return run_statement(next_ident);
			);
	return self;

func add_start_data_branch_condition(data_branch_condition: String, go_to_on_true: String, go_to_on_false: String) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func(_a = null) -> String:
			var branch_condition = Data.get(data_branch_condition)
			var next_ident = go_to_on_true;
			if !branch_condition:
				next_ident = go_to_on_false;
			return run_statement(next_ident);
			);
	return self;

func add_branch_condition(identifier: String, condition_callable: Callable, go_to_on_true: String, go_to_on_false: String) -> DialogueChain:
	_dialogue_dict[identifier] = (
		func(_a = null) -> String:
			var branch_condition: bool = condition_callable.call();
			var next_ident = go_to_on_true;
			if !branch_condition:
				next_ident = go_to_on_false;
			return run_statement(next_ident);
			);
	return self;

func add_start_branch_condition(condition_callable: Callable, go_to_on_true: String, go_to_on_false: String) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func(_a = null) -> String:
			var branch_condition: bool = condition_callable.call();
			var next_ident = go_to_on_true;
			if !branch_condition:
				next_ident = go_to_on_false;
			return run_statement(next_ident);
			);
	return self;
	
func add_prompt_branch_statement(identifier: String, dialogue: String, options: Array[Dictionary]) -> DialogueChain:
	_dialogue_dict[identifier] = (
		func(_a = null) -> String:
			var new_prompt: Prompt = Prompt.new(dialogue);
			for opt_dict in options:
				if opt_dict.has("callable"):
					new_prompt.add_option(opt_dict.description, (func() -> String: opt_dict.callable.call(); return run_statement(opt_dict.points_to)));
				else:
					new_prompt.add_option(opt_dict.description, (func() -> String: return run_statement(opt_dict.points_to)));
			Narrare.current_prompt = new_prompt;
			return Narrare.current_prompt.get_display_string();
			);
	return self;
	
func add_start_prompt_branch_statement(dialogue: String, options: Array[Dictionary]) -> DialogueChain:
	_dialogue_dict["_start_"] = (
		func(_a = null) -> String:
			var new_prompt: Prompt = Prompt.new(dialogue);
			for opt_dict in options:
				if opt_dict.has("callable"):
					new_prompt.add_option(opt_dict.description, (func() -> String: opt_dict.callable.call(); return run_statement(opt_dict.points_to)));
				else:
					new_prompt.add_option(opt_dict.description, (func() -> String: return run_statement(opt_dict.points_to)));
			Narrare.current_prompt = new_prompt;
			return Narrare.current_prompt.get_display_string();
			);
	return self;

func add_set_data_flag_statement(identifier: String, flag_name: String, flag_value: Variant, points_to: Variant = null) -> DialogueChain:
	_dialogue_dict[identifier] = (
		func(_a = null) -> String:
			Data.set(flag_name, flag_value);
			return run_statement(points_to);
			);
	return self;
