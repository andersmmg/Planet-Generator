extends EditorInspectorPlugin


const NOISE_GENERATOR_PREVIEW = preload("res://addons/hoimar.planetgen/editor/noise_generator_preview.tscn")

var _previewer

func _can_handle(object: Object) -> bool:
	return object is NoiseGenerator


func _parse_begin(object: Object) -> void:
	var generator = object as NoiseGenerator
	
	_previewer = NOISE_GENERATOR_PREVIEW.instantiate()
	add_custom_control(_previewer)
	
	_previewer.set_preview(generator)
