extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_vis_change)
	pass # Replace with function body.

func _on_vis_change():
	if is_visible_in_tree():
		grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
