extends Area2D

@export var max_radius: float = 1000.0
@export var expansion_speed: float = 500.0 #pixeles
@export var max_force: float = 1000.0
@export var force_falloff: float = 2.0

var current_radius: float = 0.0
var shockwave_active: bool = false
var collision_shape: CollisionShape2D
var elapsed_time: float = 0.0
var CorrectSound = preload("res://07038015 (mp3cut.net).wav")

@onready var shockwave_sprite: Sprite2D = $ShockwaveSprite
@onready var particles: GPUParticles2D = $ShockwaveParticles

func _ready():
	collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = 1.0
	collision_shape.shape = circle_shape
	add_child(collision_shape)
	
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	if shockwave_sprite:
		shockwave_sprite.scale = Vector2(0.01, 0.01)  # Start small
		shockwave_sprite.material = shockwave_sprite.material.duplicate()
	
	if particles:
		particles.emitting = true
	
	start_shockwave()

func start_shockwave():
	print("Started shockwave")
	$AudioStreamPlayer2D.stream = CorrectSound
	$AudioStreamPlayer2D.play()
	shockwave_active = true
	current_radius = 1.0
	elapsed_time = 0.0

func _process(delta):
	if not shockwave_active:
		return
		
	elapsed_time += delta
	current_radius += expansion_speed * delta
	
	if collision_shape and collision_shape.shape is CircleShape2D:
		var shape = collision_shape.shape as CircleShape2D
		shape.radius = current_radius
	
	if shockwave_sprite:
		var progress = min(1.0, current_radius / max_radius)
		shockwave_sprite.material.set_shader_parameter("progress", progress)
		
		var base_size = 100.0
		shockwave_sprite.scale = Vector2(current_radius / base_size, current_radius / base_size)
	
	if current_radius >= max_radius:
		shockwave_active = false
		queue_free()

func _on_body_entered(body: Node2D):
	if body is RigidBody2D:
		apply_shockwave_force(body)

func _on_area_entered(area: Area2D):
	pass

func apply_shockwave_force(body: RigidBody2D):
	var direction = (body.global_position - global_position).normalized()
	var distance = global_position.distance_to(body.global_position)
	
	var force_factor = 1.0 / pow(max(1.0, distance / 50.0), force_falloff)
	var force = direction * max_force * force_factor
	
	body.apply_central_impulse(force)
	
	var torque = force.length() * 0.1 * (1.0 if randf() > 0.5 else -1.0)
	body.apply_torque_impulse(torque)
