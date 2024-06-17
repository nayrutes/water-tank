extends Node

@onready var spawnpoints: Array[Node3D]


func _ready():
	for child in get_children():
		spawnpoints.append(child)
	EntityManager.set_spawnpoints(spawnpoints)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
