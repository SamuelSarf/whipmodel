extends Node2D

@export var pasos: int = 10
@export var longitud: float = 200.0
@export var lengitud: float = 10.0
@export var handle2: int = 0
@export var shock: Node2D
@export var mapa_de_masa: bool = false
var ultimo: Node2D
var control_points: Array[Node2D]
var masas: Vector2

func _ready() -> void:
	var paso
	var join
	var anterior
	var masas = load_csv_to_array("res://masas.map")
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
				if mapa_de_masa == true:
					paso.mass = masas[i]
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

func load_csv_to_array(file_path: String) -> Array:
	var result_array: Array = []
	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var items = content.split(",")
		for item in items:
			result_array.append(item.strip_edges())
	
	return result_array
