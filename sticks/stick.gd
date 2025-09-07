extends RigidBody2D

@export var anterior: Node2D

func _draw():
	# Draw the point (a small circle)
	draw_line(Vector2.ZERO,Vector2(50,0),Color(0,0,1),5)

func _physics_process(delta: float) -> void:
	
