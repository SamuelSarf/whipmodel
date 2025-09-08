extends RigidBody2D

@export var length: float = 100.0
@export var width: float = 20.0
@export var color: Color = Color.WHITE
@export var handle: Node2D


func _ready():
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

# Helper function to get connection points
func get_top_connection_point() -> Vector2:
	return Vector2(0, -length/2)

func get_bottom_connection_point() -> Vector2:
	return Vector2(0, length/2)
	

func _process(delta):
	if handle:
		global_position = handle.global_position
		global_rotation = handle.global_rotation
	
