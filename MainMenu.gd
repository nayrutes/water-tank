extends MarginContainer

@onready var start_button: Button = $HBoxContainer/VBoxContainer/ButtonStart
# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_game():
	GameLoop.load_level(0)
	#get_tree().change_scene_to_file("res://game.tscn")
