extends Node2D

@export var pasos: int = 10
@export var longitud: float = 200.0
@export var lengitud: float = 10.0
@export var handle2: int = 0
@export var shock: Node2D
var ultimo: Node2D
var control_points: Array[Node2D]

func _ready() -> void:
	var paso
	var join
	var anterior
	for i in pasos:
		if i == 0:
			paso = preload("res://cabeza.tscn").instantiate()
			paso.width = lengitud
			paso.length = longitud / pasos
			paso.color = Color(0,1,0)
			paso.point_position = global_position
			add_child(paso)
		else:
			if i == handle2-1:
				paso = preload("res://cabeza.tscn").instantiate()
				paso.width = lengitud
				paso.length = longitud / pasos
				paso.color = Color(0,1,0)
				paso.point_position = global_position + (Vector2(0,1)*(longitud/pasos)*i)
				join = preload("res://joint.tscn").instantiate()
				join.point_position = global_position + (Vector2(0,1)*(longitud/pasos)*(i))
				join.cosoa = anterior
				join.cosob = paso
				add_child(paso)
				add_child(join)
			else:
				paso = preload("res://cola.tscn").instantiate()
				paso.width = lengitud
				paso.length = longitud / pasos
				paso.color = Color(0,0,1)
				paso.point_position = global_position + (Vector2(0,1)*(longitud/pasos)*i)
				paso.shockwave_manager = shock
				if i == pasos-1:
					paso.punta = true
				join = preload("res://joint.tscn").instantiate()
				join.point_position = global_position + (Vector2(0,1)*(longitud/pasos)*(i))
				join.cosoa = anterior
				join.cosob = paso
				add_child(paso)
				add_child(join)
		anterior = paso
		control_points.push_back(paso)
