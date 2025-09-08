extends StaticBody2D

# The point's position (you can set initial position in the inspector)
@export var point_position: Vector2 = global_position
@export var width: float
@export var length: float
@export var color: Color
var grab_radius: float = 20.0
var is_dragging: bool = false
func _ready():
	# Set initial position
	position = point_position
	create_collision_shape()
	create_visual()

func _draw():
	# Draw the point (a small circle)
	draw_circle(Vector2.ZERO, 10, Color(1, 0, 0))  # Red circle at point's position
	
	# Draw a larger transparent circle for the grab area (visible only in debug)
	if OS.is_debug_build():
		draw_circle(Vector2.ZERO, grab_radius, Color(1, 1, 1, 0.2))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if click is within grab radius
				var local_mouse_pos = get_global_mouse_position()
				if global_position.distance_to(local_mouse_pos) <= grab_radius:
					is_dragging = true
			else:
				is_dragging = false
	
	elif event is InputEventMouseMotion and is_dragging:
		# Update position while dragging
		global_position = get_global_mouse_position()
		point_position = global_position
		queue_redraw()  # Redraw to update the point's position

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
