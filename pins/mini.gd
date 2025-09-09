extends RigidBody2D

@export var point_position: Vector2 = global_position
@export var width: float = 10.0
@export var length: float
@export var color: Color
@export var punta: bool =false
var speed_label: Label
@export var shockwave_manager: Node2D
var booming: bool = false

func _ready():
	# Set initial position
	position = point_position
	create_collision_shape()
	create_visual()
	speed_label = get_node("/root/Node2D/Label")
	
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
	
func _physics_process(delta: float) -> void:
	if punta:
		var speed = linear_velocity.length()/100
		speed_label.text = "Velocidad punta: " + str(snapped(pow(speed,1.4), 0.1))
		if pow(speed,1.4) >= 343 and booming == false:
			booming = true
			create_sonic_boom()
		elif pow(speed,1.4) <= 300:
			booming = false

func create_sonic_boom():
	if shockwave_manager:
		shockwave_manager.create_shockwave(
			global_position, 
			1500.0,  # max_radius
			800.0,   # expansion_speed
			1500.0   # max_force
		)
