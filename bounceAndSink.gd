extends Node3D

var rb: RigidBody3D
var sinking:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	rb = owner
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(rb.global_position.y < -5):
		rb.queue_free()

func _physics_process(delta):
	if(sinking):
		rb.apply_central_force(Vector3.DOWN * 100.0 * delta)

func _on_hittable_hit(pos, dir):
	sinking = true
	var impulse = dir + Vector3.DOWN * 1.0
	rb.apply_impulse(impulse, pos)
