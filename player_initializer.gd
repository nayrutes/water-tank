extends Node

@export var spawnpoints: Array[Node3D]
@onready var tank_scene = preload("res://shipTank.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.player_joined.connect(_on_player_joined)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_joined(player: int):
	var tank = tank_scene.instantiate()
	tank.setup(spawnpoints[player+1], player)
	get_tree().root.add_child(tank)
	pass
