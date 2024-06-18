extends MarginContainer

@onready var continue_button: Button = $main/PanelContainer/MarginContainer/VBoxContainer/Continue
@onready var main_menu_button: Button = $main/PanelContainer/MarginContainer/VBoxContainer/ButtonMainMenu
@onready var settings_button: Button = $main/PanelContainer/MarginContainer/VBoxContainer/ButtonSettings
@onready var credits_button: Button = $main/PanelContainer/MarginContainer/VBoxContainer/ButtonCredits

@onready var main: Container = $main
@onready var credits: Container = $credits
@onready var settings: Container = $settings

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	PlayerManager.menu_pressed.connect(_toggle_menu)
	main.visibility_changed.connect(_on_vis_change)
	pass # Replace with function body.

func _on_vis_change():
	if main.is_visible_in_tree():
		continue_button.grab_focus()

func _toggle_menu():
	visible = !visible
	if visible:
		continue_button.grab_focus()

func _load_main_menu():
	GameLoop.load_level(-1)


func _on_continue_pressed():
	visible = false
	pass # Replace with function body.

func _on_toggle_credits():
	main.visible = !main.visible
	credits.visible = !credits.visible

func _on_toggle_settings():
	main.visible = !main.visible
	settings.visible = !settings.visible
