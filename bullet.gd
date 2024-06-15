extends Area3D

@export var speed: float = 800.0
@export var damage: int = 30

var origin_shooter: RigidBody3D

func _physics_process(delta):
	var forward = -global_transform.basis.z
	position = position + forward * speed * delta

func setup(trans: Transform3D, shooter: RigidBody3D):
	transform = trans
	origin_shooter = shooter
	print(origin_shooter)

func _on_other_entered(other):
	if(other == origin_shooter):
		return
	
	trigger_hittable_on_body(other)
	if other.is_in_group("enemy"):
		pass
	if other.is_in_group("environment"):
		pass
	if other.is_in_group("bullet"):
		pass
	print("hit: ", other)
	queue_free()
	
func trigger_hittable_on_body(body):
	var path_to_hittable = "Hittable"
	# Check if the path exists
	if body.has_node(path_to_hittable):
		var hittable_node = body.get_node(path_to_hittable)
		hittable_node.on_hit(global_position, Vector3.FORWARD * transform.affine_inverse())
	else:
		print("No Hittable found at path: ", path_to_hittable)
	
	
