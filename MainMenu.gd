extends MarginContainer

@onready var start_button: Button = $main/VBoxContainer/ButtonStart

@onready var main: Container = $main
@onready var credits: Container = $credits
@onready var settings: Container = $settings

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()
	main.visibility_changed.connect(_on_vis_change)
	pass # Replace with function body.

func _on_vis_change():
	if main.is_visible_in_tree():
		start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_game():
	GameLoop.load_level(0)
	#get_tree().change_scene_to_file("res://game.tscn")

func _on_toggle_credits():
	main.visible = !main.visible
	credits.visible = !credits.visible

func _on_toggle_settings():
	main.visible = !main.visible
	settings.visible = !settings.visible
