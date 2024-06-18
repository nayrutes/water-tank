extends Node

var allow_self_hit: bool = true
signal self_hit_toggled(new_state:bool)

var allow_team_hit: bool = false
signal team_hit_toggled(new_state:bool)

var music_enabled: bool = true
signal music_toggled(new_state:bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func toggle_self_hit(new_state:bool):
	allow_self_hit = new_state
	self_hit_toggled.emit(new_state)

func toggle_team_hit(new_state:bool):
	allow_team_hit = new_state
	team_hit_toggled.emit(new_state)

func toggle_music(new_state:bool):
	music_enabled = new_state
	music_toggled.emit(new_state)
