@tool
extends Container

@onready var preview_texture: TextureRect = %PreviewTexture
@onready var zoom_in_button: Button = %ZoomInButton
@onready var zoom_out_button: Button = %ZoomOutButton
@onready var zoom_reset_button: Button = %ZoomResetButton

const ZOOM_MIN = 10
const ZOOM_MAX = 200
const ZOOM_DEFAULT = 100
const ZOOM_STEP = 1.2

var _zoom_scale = 100

var _noise_generator: NoiseGenerator:
	set(value):
		if _noise_generator:
			_noise_generator.updated.disconnect(_update_texture)

		_noise_generator = value

		if _noise_generator:
			_noise_generator.updated.connect(_update_texture)
			_update_texture.call_deferred()


func _ready() -> void:
	_set_icons()
	#preview_texture.texture = preview_texture.texture.duplicate()
	_update_texture()


func set_preview(generator: NoiseGenerator):
	_noise_generator = generator


func _set_icons() -> void:
	var editor_theme = EditorInterface.get_editor_theme()
	zoom_in_button.icon = editor_theme.get_icon("ZoomMore", "EditorIcons")
	zoom_out_button.icon = editor_theme.get_icon("ZoomLess", "EditorIcons")
	zoom_reset_button.icon = editor_theme.get_icon("ZoomReset", "EditorIcons")


func _update_texture() -> void:
	if not preview_texture or not _noise_generator:
		return
	if not preview_texture.texture is NoiseTexture2D:
		var new_texture := NoiseTexture2D.new()
		preview_texture.texture = new_texture
	var new_noise: FastNoiseLite = _noise_generator._simplex.duplicate()
	new_noise.frequency /= _zoom_scale
	preview_texture.texture.noise = new_noise


func _on_zoom_in_button_pressed() -> void:
	_zoom_scale = clampi(_zoom_scale * ZOOM_STEP, ZOOM_MIN, ZOOM_MAX)
	_update_texture()


func _on_zoom_out_button_pressed() -> void:
	_zoom_scale = clampi(_zoom_scale / ZOOM_STEP, ZOOM_MIN, ZOOM_MAX)
	_update_texture()


func _on_zoom_reset_button_pressed() -> void:
	_zoom_scale = ZOOM_DEFAULT
	_update_texture()
