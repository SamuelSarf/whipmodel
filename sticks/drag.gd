extends Node2D

# The point's position (you can set initial position in the inspector)
@export var point_position: Vector2 = Vector2(100, 100)

# Size of the draggable area around the point
var grab_radius: float = 20.0

# Flag to check if we're currently dragging
var is_dragging: bool = false

func _ready():
	# Set initial position
	position = point_position

func _draw():
	# Draw the point (a small circle)
	draw_line(Vector2.ZERO,Vector2(50,0),Color(1,0,0),5)
	
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
