extends RichTextLabel

var credits_path = "res://external_credits.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open(credits_path, FileAccess.READ)
	var content = file.get_as_text()
	text = content
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
