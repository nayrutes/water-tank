extends Area3D

@export var speed: float = 800.0
@export var bounces: int = 2

var origin_shooter: RigidBody3D
var shoot_cooldown: float = 0.5

func _process(delta):
	shoot_cooldown = maxf(shoot_cooldown-delta, -1)

func _physics_process(delta):
	var forward = -global_transform.basis.z
	position = position + forward * speed * delta

func setup(trans: Transform3D, shooter: RigidBody3D):
	transform = trans
	origin_shooter = shooter
	print(origin_shooter)

func _on_other_entered(other):
	  #print("origin: ", origin_shooter, "--other: ", other)
	if(other == origin_shooter && (shoot_cooldown > 0 || !GameSettings.allow_self_hit)):
		return
	if(other != origin_shooter && origin_shooter.is_in_group("player") && other.is_in_group("player") && !GameSettings.allow_team_hit):
		print("returning because of team hit")
		return
	
	var destroy = false
	trigger_hittable_on_body(other)
	if other.is_in_group("enemy"):
		destroy = true
		pass
	if other.is_in_group("environment"):
		pass
	if other.is_in_group("bullet"):
		destroy = true
		#print("bullet hit")
		pass
	#print("hit: ", other)
	if(bounces <= 0):
		destroy = true
	
	if destroy:
		queue_free()
		return
	
	var forward_gl = -global_transform.basis.z
	var col_normal = raycast_for_collision_normal(global_position, forward_gl)
	if col_normal == Vector3.ZERO:
		queue_free()
		return
	
	var new_dir = calculate_reflection_vector(forward_gl, col_normal)
	new_dir.y = 0
	new_dir = new_dir.normalized()
	global_basis = global_basis.looking_at(new_dir,Vector3.UP)
	#basis = basis.orthonormalized()
	#print("original fw: ", forward_gl)
	#print("normal: ", col_normal)
	#print("new fw: ", new_dir)
	bounces -= 1

func calculate_reflection_vector(direction: Vector3, normal: Vector3) -> Vector3:
	var dot_product = direction.dot(normal)
	var reflection = direction - 2.0 * dot_product * normal
	return reflection

	
func trigger_hittable_on_body(other):
	var path_to_hittable = "Hittable"
	# Check if the path exists
	if other.has_node(path_to_hittable):
		var hittable_node = other.get_node(path_to_hittable)
		hittable_node.on_hit(global_position, Vector3.FORWARD * transform.affine_inverse(), self)
	else:
		print("No Hittable found at path: ", path_to_hittable)


func raycast_for_collision_normal(pos, direction) -> Vector3:
	var from = pos
	var to = pos + direction*5

	var space_state = get_world_3d().direct_space_state
	var param: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(param)
	#print("cast pos: ",from, " to: ", to, " with: ", direction)
	if result:
		#print(result)
		var normal = result.normal
		normal.y = 0
		normal = normal.normalized()
		return normal
	return Vector3.ZERO
