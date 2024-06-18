extends HBoxContainer

@onready var friendly_fire_toggle = $PanelContainer/MarginContainer/VBoxContainer/FreindlyFire
@onready var self_fire_toggle = $PanelContainer/MarginContainer/VBoxContainer/SelfFire
@onready var music_toggle = $PanelContainer/MarginContainer/VBoxContainer/Music

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(vis_changed)
	friendly_fire_toggle.toggled.connect(fft)
	self_fire_toggle.toggled.connect(sft)
	music_toggle.toggled.connect(mt)
	pass # Replace with function body.

func vis_changed():
	if is_visible_in_tree():
		friendly_fire_toggle.button_pressed = GameSettings.allow_team_hit
		self_fire_toggle.button_pressed = GameSettings.allow_self_hit
		music_toggle.button_pressed = GameSettings.music_enabled

func fft(new_state:bool):
	GameSettings.toggle_team_hit(new_state)

func sft(new_state:bool):
	GameSettings.toggle_self_hit(new_state)
	
func mt(new_state:bool):
	GameSettings.toggle_music(new_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
