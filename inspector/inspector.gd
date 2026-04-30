@tool
extends Control

const GradientDrawer := preload("./gradient_drawer.gd")

signal target_set(GradientOfGradients)
signal target_changed

var _target: GradientOfGradients


func set_target(target: GradientOfGradients) -> void:
	_disconnect_change_signal()
	_target = target
	_connect_change_signal()
	target_set.emit(target)


#region Change listening

func _exit_tree() -> void:
	_disconnect_change_signal()


func _connect_change_signal() -> void:
	_disconnect_change_signal()

	if _target == null:
		return

	_target.changed.connect(target_changed.emit)


func _disconnect_change_signal() -> void:
	if _target != null and _target.changed.is_connected(target_changed.emit):
		_target.changed.disconnect(target_changed.emit)
