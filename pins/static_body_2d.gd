extends StaticBody2D

@export var point_position: Vector2 = global_position
@export var width: float
@export var length: float
@export var color: Color
@export var rotation_speed: float = PI
var grab_radius: float = 20.0
var is_dragging: bool = false
func _ready():
	# Set initial position
	position = point_position
	create_collision_shape()
	create_visual()

func _draw():
	draw_circle(Vector2.ZERO, 10, Color(1, 0, 0))
	
	if OS.is_debug_build():
		draw_circle(Vector2.ZERO, grab_radius, Color(1, 1, 1, 0.2))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var local_mouse_pos = get_global_mouse_position()
				if global_position.distance_to(local_mouse_pos) <= grab_radius:
					is_dragging = true
			else:
				is_dragging = false
		if event is InputEventMouseButton:
			var local_mouse_pos = get_global_mouse_position()
			if global_position.distance_to(local_mouse_pos) <= grab_radius:
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					rotate(rotation_speed * get_process_delta_time())
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					rotate(-rotation_speed * get_process_delta_time())
	
	elif event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position()
		point_position = global_position
		queue_redraw()

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
	color_rect.position = Vector2(-length/2, -width/2)
	add_child(color_rect)
