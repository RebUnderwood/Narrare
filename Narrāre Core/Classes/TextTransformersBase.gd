extends Node
class_name TextTransformersBase

func register_transformers(...transformers: Array) -> void:
	for transformer in transformers:
		assert(transformer is Callable, "ERROR: Registered text transformers must be type Callable.")
	Narrare.register_text_transformers.callv(transformers);
