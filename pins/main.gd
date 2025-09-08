extends Node2D

@export var pasos: int = 10
@export var longitud: float = 200.0
@export var lengitud: float = 10.0

func _ready() -> void:
	var paso
	var join
	var anterior
	for i in pasos:
		if i == 0:
			paso = preload("res://cabeza.tscn").instantiate()
			paso.width = lengitud
			paso.length = longitud / pasos
			paso.color = Color(1,0,0)
			paso.point_position = global_position
		else:
			paso = preload("res://cola.tscn")
			paso.width = lengitud
			paso.length = longitud / pasos
			paso.color = Color(1,0,0)
			paso.point_position = global_position + (Vector2(0,1)*(longitud/pasos)*i)
			join = preload("res://joint.tscn")
			join.cosoa = anterior
			join.cosob = paso
			join.point_position = global_position + (Vector2(0,1)*(longitud/pasos)*i)
			add_child(join)
		add_child(paso)
		anterior = paso
		print(paso.width)
