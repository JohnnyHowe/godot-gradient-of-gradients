@tool
extends Button

@export var _resolution: float = 16
@export var _target_width: float = 24
@export var _texture_rect: TextureRect

var target: GradientPoint

var _held: bool = false


func _init() -> void:
	button_down.connect(func(): _held = true)
	button_up.connect(func(): _held = false)


func set_gradient(gradient_point: GradientPoint) -> void:
	target = gradient_point


func _process(_delta: float) -> void:
	if not visible:
		return
	if target == null:
		return
	_update()


func _update() -> void:
	_update_layout()
	_update_texture()

	if _held:
		_move_to_mouse()
	

func _update_layout() -> void:
	var parent: Control = get_parent()
	size.x = _target_width

	var x: float = lerp(0.0, parent.size.x - size.x, target.t)
	position = Vector2(x, 0)


func _update_texture() -> void:
	var new_texture := GradientTexture1D.new()
	new_texture.gradient = target.gradient
	new_texture.width = _resolution
	_texture_rect.texture = new_texture


func _move_to_mouse() -> void:
	target.t = _get_normalized_mouse_position().x


func _get_normalized_mouse_position() -> Vector2:
	var parent: Control = get_parent()
	var mouse_position_in_parent := parent.get_local_mouse_position()
	return Vector2(
		clamp(mouse_position_in_parent.x / parent.size.x, 0, 1),
		clamp(mouse_position_in_parent.y / parent.size.y, 0, 1)
	)
