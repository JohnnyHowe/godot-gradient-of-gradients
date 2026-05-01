@tool
class_name GradientOfGradients
extends Resource

@export var gradients: Array[GradientPoint]:
	set(value):
		gradients = value
		_add_changed_listeners_to_gradients()
		changed.emit()

@export var _ping_pong: bool:
	set(value):
		if value != _ping_pong:
			_ping_pong = value
			changed.emit()


func _add_changed_listeners_to_gradients() -> void:
	for gradient: GradientPoint in gradients:
		_add_changed_listeners_to_gradient(gradient)


func _add_changed_listeners_to_gradient(gradient_point: GradientPoint) -> void:
	if not is_instance_valid(gradient_point):
		return
	if gradient_point.changed.is_connected(changed.emit):
		return
	gradient_point.changed.connect(changed.emit)


## Warning, this is slow.
func create_texture(size: Vector2i, format := Image.FORMAT_RGB8) -> ImageTexture:
	return ImageTexture.create_from_image(create_image(size, format))


## Warning, this is slow.
func create_image(size: Vector2i, format := Image.FORMAT_RGB8) -> Image:
	var image := Image.create_empty(size.x, size.y, false, format)

	for x in range(size.x):
		var x_normalized := float(x) / (size.x - 1)
		for y in range(size.y):
			var y_normalized := 0.5
			if size.y > 1:
				y_normalized = float(y) / (size.y - 1)

			var normalized_position := Vector2(x_normalized, y_normalized)
			image.set_pixel(x, y, sample(normalized_position))

	return image


func sample_x_as_texture(x: float, resolution: int = 32) -> GradientTexture1D:
	var texture := GradientTexture1D.new()
	texture.gradient = sample_x_as_gradient(x, resolution)
	texture.width = resolution
	return texture


func sample_x_as_gradient(x: float, resolution: int = 32) -> Gradient:
	var gradient := Gradient.new()
	for sample_index in range(resolution):
		var sample_y: float = float(sample_index) / (resolution - 1)
		gradient.add_point(sample_y, sample(Vector2(x, sample_y)))
	return gradient


func sample(position: Vector2) -> Color:
	position.x = clamp(position.x, 0, 1)
	position.y = clamp(position.y, 0, 1)

	if _ping_pong:
		if position.x < 0.5:
			position.x *= 2
		else:
			position.x = 1.0 - inverse_lerp(0.5, 1.0, position.x)

	var neighbouring_gradients := _get_neighbouring_gradients(position.x)

	if neighbouring_gradients.is_empty():
		return Color(0, 0, 0, 0)

	if neighbouring_gradients.size() == 1:
		return neighbouring_gradients[0].gradient.sample(position.y)

	if neighbouring_gradients.size() > 2:
		push_error("Got 2 neighbouring gradients???")

	var left_gradient_point := neighbouring_gradients[0]
	var right_gradient_point := neighbouring_gradients[1]

	var left_sample := left_gradient_point.gradient.sample(position.y)
	var right_sample := right_gradient_point.gradient.sample(position.y)
	var weight: float = inverse_lerp(left_gradient_point.t, right_gradient_point.t, position.x)

	return lerp(left_sample, right_sample, weight)


static func lerp_gradients(start: Gradient, end: Gradient, weight: float, resolution: int = 32) -> Gradient:
	weight = clamp(weight, 0, 1)
	resolution = max(resolution, 2)

	var result := Gradient.new()

	for sample_index in range(resolution):
		var sample_t := float(sample_index) / (resolution - 1)
		var start_sample := start.sample(sample_t)
		var end_sample := end.sample(sample_t)
		result.add_point(sample_t, start_sample.lerp(end_sample, weight))

	return result


func _get_neighbouring_gradients(x: float) -> Array[GradientPoint]:
	if gradients.is_empty():
		return []

	var sorted_gradients := _get_sorted_gradients()

	if sorted_gradients.is_empty():
		return []

	if sorted_gradients.size() == 1:
		return [sorted_gradients[0]]

	if x <= sorted_gradients[0].t:
		return [sorted_gradients[0]]

	for i in range(sorted_gradients.size() - 1):
		var left: GradientPoint = sorted_gradients[i]
		var right: GradientPoint = sorted_gradients[i + 1]
		if x <= right.t:
			return [left, right]

	var last: GradientPoint = sorted_gradients.back()
	return [last, last]


func _get_sorted_gradients() -> Array[GradientPoint]:
	var sorted_gradients := get_valid_gradient_points()
	sorted_gradients.sort_custom(
		func(a: GradientPoint, b: GradientPoint) -> bool:
			return a.t < b.t
	)
	return sorted_gradients


func get_valid_gradient_points() -> Array[GradientPoint]:
	var points: Array[GradientPoint] = []
	for point in gradients:
		if point == null:
			continue
		if point.gradient == null:
			continue
		points.append(point)
	return points
