@tool
extends EditorPlugin

var _inspector: EditorInspectorPlugin


func _enter_tree() -> void:
	_inspector = preload("./inspector/inspector_plugin.gd").new()
	add_inspector_plugin(_inspector)


func _exit_tree() -> void:
	if _inspector != null:
		remove_inspector_plugin(_inspector)
		_inspector = null
