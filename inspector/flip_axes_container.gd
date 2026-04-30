@tool
extends CustomContainerBase


func arrange_children(children: Array[Control]) -> void:
	for child in children:
		_arrange_child(child)


func _arrange_child(child: Control) -> void:
	child.pivot_offset = Vector2.ZERO
	child.pivot_offset_ratio = Vector2.ZERO

	child.scale = Vector2.ONE

	child.size.x = size.y
	child.size.y = size.x

	child.rotation_degrees = -90
	child.position.x = 0
	child.position.y = child.size.x
