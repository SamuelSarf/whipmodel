extends RigidBody2D

func _draw():
	# Draw the point (a small circle)
	draw_circle(Vector2.ZERO, 10, Color(1, 0, 0))  # Red circle at point's position


@export var target_node: Node2D
@export var target_node2: Node2D
var nodos = 5
var longitud = 50
var sep = longitud/nodos
var hooke = 37.0
  # Drag and drop the target node in the inspector
var ancla = Vector2(0,1)*sep
func _physics_process(delta):
	var repulsion = Vector2(0,0)
	for node in get_tree().get_nodes_in_group("particles"):
		if node != self and is_instance_valid(node):
			var repulsion_temp = node.global_position - global_position
			repulsion_temp = repulsion_temp.normalized()
			var distancia_temp = global_position.distance_to(node.global_position)
			if distancia_temp >= 15:
				repulsion_temp *= -100000/((distancia_temp-15)*(distancia_temp-15))
			else:
				repulsion_temp *= -100000/((distancia_temp)*(distancia_temp))
			repulsion += repulsion_temp
	if target_node:
		var atraccion = target_node.global_position - global_position + ancla
		atraccion = atraccion.normalized()
		var damp = atraccion*(-1)
		var distancia2 = global_position.distance_to(target_node.global_position + ancla)
		atraccion *= hooke*(distancia2)
		
		var vel
		if target_node is RigidBody2D:
			vel = linear_velocity - target_node.linear_velocity
		else:
			vel = linear_velocity
		var dot = vel.dot(damp)
		damp *= -50*(dot)
		var tot = atraccion + damp
		apply_force(tot)
		
	if target_node2:
		# Calculate direction vector from current position to target
		var atraccion = target_node2.global_position - global_position
		# Normalize it to get a unit vector (length = 1)
		atraccion = atraccion.normalized()
		
		# Normalize it to get a unit vector (length = 1)
		repulsion = repulsion.normalized()
		
		var distancia = global_position.distance_to(target_node.global_position)
		atraccion *= 1*distancia/10
		repulsion *= -10000/((distancia-5)*(distancia-5))
		apply_force(repulsion)
		#apply_force(atraccion)
	apply_force(repulsion)

func _ready():
	# Connect to the global signal
	SignalBus.slider_value_changed.connect(_on_slider_value_changed)
	
func _on_slider_value_changed(value: float):
	hooke = value
