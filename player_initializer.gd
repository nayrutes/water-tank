extends Node

@onready var spawnpoints: Array[Node3D]
@onready var tank_scene = preload("res://shipTank.tscn")
@export var playerColors: Array[StandardMaterial3D] = [preload("res://materials/pl1.tres"),
preload("res://materials/pl2.tres"),
preload("res://materials/pl3.tres"),
preload("res://materials/pl4.tres"),
preload("res://materials/pl5.tres")]


func _ready():
	PlayerManager.player_joined.connect(_on_player_joined)
	for child in get_children():
		spawnpoints.append(child)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_joined(player: int):
	var tank = tank_scene.instantiate()
	tank.setup(spawnpoints[player+1], player, get_player_color(player))
	get_tree().root.add_child(tank)
	pass

func get_player_color(player) -> StandardMaterial3D:
	return playerColors[player+1]
