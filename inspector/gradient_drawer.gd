@tool
extends Button

@export var _resolution: float = 16
@export var _target_width: float = 24
@export var _texture_rect: TextureRect

var _target: GradientOfGradients
var _target_point: GradientPoint

var _held: bool = false


func _init() -> void:
	button_down.connect(func(): _held = true)
	button_up.connect(func(): _held = false)


func set_target(target: GradientOfGradients) -> void:
	_target = target


func set_gradient(gradient_point: GradientPoint) -> void:
	_target_point = gradient_point


func _process(_delta: float) -> void:
	if not visible:
		return
	if _target_point == null:
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

	var x: float = lerp(0.0, parent.size.x - size.x, _target_point.t)
	if _target != null and _target._ping_pong:
		x = x / 2.0
	position = Vector2(x, 0)


func _update_texture() -> void:
	var new_texture := GradientTexture1D.new()
	new_texture.gradient = _target_point.gradient
	new_texture.width = _resolution
	_texture_rect.texture = new_texture


func _move_to_mouse() -> void:
	var normalized_mouse_x := _get_normalized_mouse_position().x
	if _target != null and _target._ping_pong:
		normalized_mouse_x *= 2
	_target_point.t = normalized_mouse_x


func _get_normalized_mouse_position() -> Vector2:
	var parent: Control = get_parent()
	var mouse_position_in_parent := parent.get_local_mouse_position()
	return Vector2(
		clamp(mouse_position_in_parent.x / parent.size.x, 0, 1),
		clamp(mouse_position_in_parent.y / parent.size.y, 0, 1)
	)
