extends AudioStreamPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	GameSettings.music_toggled.connect(toggle_music)
	if GameSettings.music_enabled:
		play()
	pass # Replace with function body.

func toggle_music(new_state: bool):
	if new_state:
		if !playing:
			play()
	else:
		stop()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
