extends Node

var player_tanks: Array[Node3D]
var enemy_tanks: Array[Node3D]

@onready var tank_scene = preload("res://shipTank.tscn")
@export var playerColors: Array[StandardMaterial3D] = [preload("res://materials/pl1.tres"),
preload("res://materials/pl2.tres"),
preload("res://materials/pl3.tres"),
preload("res://materials/pl4.tres"),
preload("res://materials/pl5.tres")]

var spawnpoints: Array[Node3D]
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.player_joined.connect(_on_player_joined)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !GameLoop.is_level_active || PlayerManager.get_player_indexes().size() == 0:
		return
		
	if enemy_tanks.size() == 0:
		GameLoop.is_level_active = false
		print("players won")
		GameLoop.load_next_level()
	if player_tanks.size() == 0:
		GameLoop.is_level_active = false
		print("players lost")
		GameLoop.load_current_level()
	pass

func get_closest_player(o_pos: Vector3) -> Node3D:
	var dist: float = INF
	var ret = null
	for t in player_tanks:
		if !t.is_inside_tree():
			continue
		var d = o_pos.distance_to(t.global_position)
		if(d < dist):
			dist = d
			ret = t
	return ret

func instantiate_entities():
	pass
	

func set_spawnpoints(sps):
	spawnpoints = sps
	var players = PlayerManager.get_player_indexes()
	for p in players:
		spawn_player(p)

func _on_player_joined(player: int):
	spawn_player(player)
	pass

func spawn_player(player: int):
	var tank = tank_scene.instantiate()
	tank.setup(spawnpoints[player], player, get_player_color(player))
	get_tree().root.get_node("Base").add_child.call_deferred(tank)
	

func get_player_color(player) -> StandardMaterial3D:
	return playerColors[player+1]

func clear():
	player_tanks.clear()
	enemy_tanks.clear()
