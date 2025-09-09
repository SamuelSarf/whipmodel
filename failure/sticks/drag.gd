extends Node2D

@export var point_position: Vector2 = Vector2(100, 100)

var grab_radius: float = 20.0

var is_dragging: bool = false

func _ready():
	position = point_position

func _draw():
	draw_circle(Vector2.ZERO,10,Color(1,0,0))
	
	if OS.is_debug_build():
		draw_circle(Vector2.ZERO, grab_radius, Color(1, 1, 1, 0.2))
	rotation = 0
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var local_mouse_pos = get_global_mouse_position()
				if global_position.distance_to(local_mouse_pos) <= grab_radius:
					is_dragging = true
			else:
				is_dragging = false
	
	elif event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position()
		point_position = global_position
		queue_redraw()  
