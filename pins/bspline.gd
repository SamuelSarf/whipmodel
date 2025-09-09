extends Node2D

var control_points: Array[Node2D]
@export var line: Line2D
@export var resolution: int = 20
@export var source_object: Node

func _ready():
	resolution = source_object.pasos
	if line == null:
		line = Line2D.new()
		line.width = 3.0
		line.default_color = Color.RED
		add_child(line)

func _process(_delta):
	control_points = source_object.control_points
	if control_points.size() < 2:
		return
	
	var points = []
	
	for i in range(0, control_points.size() - 3):
		for t in range(resolution + 1):
			var u = float(t) / resolution
			var point = calculate_bspline_point(
				control_points[i].global_position,
				control_points[i + 1].global_position,
				control_points[i + 2].global_position,
				control_points[i + 3].global_position,
				u
			)
			points.append(point)
	
	line.points = PackedVector2Array(points)

func calculate_bspline_point(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var t2 = t * t
	var t3 = t2 * t
	
	var b0 = (-t3 + 3*t2 - 3*t + 1) / 6.0
	var b1 = (3*t3 - 6*t2 + 4) / 6.0
	var b2 = (-3*t3 + 3*t2 + 3*t + 1) / 6.0
	var b3 = t3 / 6.0
	
	return b0 * p0 + b1 * p1 + b2 * p2 + b3 * p3
