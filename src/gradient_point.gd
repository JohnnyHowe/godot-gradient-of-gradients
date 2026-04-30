@tool
class_name GradientPoint
extends Resource

@export var gradient: Gradient:
	set(value):
		gradient = value
		changed.emit()
		if not gradient.changed.is_connected(changed.emit):
			gradient.changed.connect(changed.emit)


@export var t: float:
	set(value):
		t = clamp(value, 0, 1)
		changed.emit()
