extends Node2D

@export var shockwave_scene: PackedScene

func create_shockwave(position: Vector2, max_radius: float = 1000.0, 
					 expansion_speed: float = 500.0, max_force: float = 1000.0):
	if shockwave_scene == null:
		push_error("Shockwave scene not assigned!")
		return null
		
	var shockwave = shockwave_scene.instantiate()
	shockwave.global_position = position
	shockwave.max_radius = max_radius
	shockwave.expansion_speed = expansion_speed
	shockwave.max_force = max_force
	
	get_tree().current_scene.add_child(shockwave)
	return shockwave
