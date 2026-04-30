@tool
extends Control

const GradientDrawer := preload("./gradient_drawer.gd")

@export var _texture_rect: TextureRect
@export var _gradient_drawer_prototype: GradientDrawer
@export var texture_size: Vector2i = Vector2i(10, 10)

var _target: GradientOfGradients
var _gradient_drawers: Array[GradientDrawer] = []


func _enter_tree() -> void:
	_gradient_drawer_prototype.visible = false


func set_target(target: GradientOfGradients) -> void:
	_target = target
	refresh()


func refresh() -> void:
	_update_texture()
	_update_gradient_drawers()


func _update_texture() -> void:
	_texture_rect.texture = _target.create_texture(texture_size, Image.FORMAT_RGBA16)


func _update_gradient_drawers() -> void:
	var valid_points := _target.get_valid_gradient_points()

	# create new drawers (if required)
	var drawers_to_create: int = max(0, valid_points.size() - _gradient_drawers.size())
	for i in range(drawers_to_create):
		_create_new_gradient_drawer()

	# update drawers
	for drawer_index in range(_gradient_drawers.size()):
		var drawer: GradientDrawer = _gradient_drawers[drawer_index]
		if drawer_index >= valid_points.size():
			drawer.visible = false
		else:
			drawer.visible = true
			drawer.set_gradient(valid_points[drawer_index])
			drawer.set_target(_target)


func _create_new_gradient_drawer() -> void:
	var new_drawer := _gradient_drawer_prototype.duplicate()
	_gradient_drawer_prototype.get_parent().add_child(new_drawer)
	new_drawer.visible = true
	_gradient_drawers.append(new_drawer)
