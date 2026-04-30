@tool
extends EditorInspectorPlugin


const _inspector_scene: PackedScene = preload("./inspector.tscn")
var _inspector_instance: Control 


func _can_handle(object: Object) -> bool:
	return object is GradientOfGradients


func _parse_begin(object: Object) -> void:
	if _inspector_instance == null:
		_inspector_instance = _inspector_scene.instantiate()
	_inspector_instance.set_target(object)
	add_custom_control(_inspector_instance)
