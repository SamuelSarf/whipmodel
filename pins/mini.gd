extends RigidBody2D

@export var point_position: Vector2 = global_position
@export var width: float
@export var length: float
@export var color: Color

func _ready():
	# Set initial position
	position = point_position
	create_collision_shape()
	create_visual()
	
func create_collision_shape():
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(width, length)
	collision.shape = shape
	add_child(collision)

func create_visual():
	var color_rect = ColorRect.new()
	color_rect.size = Vector2(width, length)
	color_rect.color = color
	color_rect.position = Vector2(-length/2, -width/2)  # Center the visual
	add_child(color_rect)
