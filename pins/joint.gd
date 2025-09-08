extends PinJoint2D

@export var cosoa: Node2D
@export var cosob: Node2D
@export var point_position: Vector2 = global_position

func _ready() -> void:
	position = point_position
	node_a = cosoa.get_path()
	node_b = cosob.get_path()
