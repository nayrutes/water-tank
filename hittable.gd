extends Node

signal hit(pos:Vector3, dir:Vector3, other: Variant)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_hit(pos:Vector3, dir:Vector3, other: Variant):
	hit.emit(pos, dir, other)
	print("got hit: ",self," of ",owner)
