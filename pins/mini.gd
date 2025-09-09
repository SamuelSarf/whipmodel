extends RigidBody2D

@export var point_position: Vector2 = global_position
@export var width: float = 10.0
@export var length: float
@export var color: Color
@export var punta: bool =false
var speed_label: Label
@export var shockwave_manager: Node2D
var booming: bool = false
@export var drag_coefficient: float = 0.47 
@export var cross_sectional_area: float = 1.0
@export var air_density: float = 1.225
@export var relativista: bool = false

func _ready():
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
	var speed = linear_velocity.length()/100
	if punta:
		if pow(speed,1.4) >= 343 and booming == false:
			booming = true
			create_sonic_boom()
		elif pow(speed,1.4) <= 300:
			booming = false
		if relativista == false:
			speed_label.text = "Velocidad punta: " + str(snapped(pow(speed,1.4), 0.1)) + " m/s"
		else:
			speed_label.text = "Velocidad punta: " + str(snapped(speed/299792458000.0, 0.001)) + "c"
	
	if speed > 0:
		var drag_magnitude = 0.5 * drag_coefficient * air_density * cross_sectional_area * speed * speed
		var drag_force = -linear_velocity.normalized() * drag_magnitude
		apply_central_force(drag_force)

func create_sonic_boom():
	if shockwave_manager:
		shockwave_manager.create_shockwave(
			global_position, 
			1500.0,  # radiomax
			800.0,   # velocidad
			1500.0   # fuerza
		)
