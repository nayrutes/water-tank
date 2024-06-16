extends Node

var player_tanks: Array[Node3D]
var enemy_tanks: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_closest_player(o_pos: Vector3) -> Node3D:
	var dist: float = INF
	var ret = null
	for t in player_tanks:
		#if t.is_destroyed:
		#	continue
		var d = o_pos.distance_to(t.global_position)
		if(d < dist):
			dist = d
			ret = t
	return ret
