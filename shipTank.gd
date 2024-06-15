extends RigidBody3D

var is_shot_cd: bool = false

@export var playerId = 0
@export var prespawned: bool

@export_category("Componenets")
@onready var shot_timer: Timer = $ShotTimer
@onready var bullet_scene = preload("res://bullet.tscn")
@onready var agent = $NavigationAgent3D
@export var bullet_spawn_path: NodePath
@export var turret_path: NodePath

var bullet_spawn_pos: Node3D
var turret_node: Node3D
var input
var setup_done: bool
var is_bot: bool
var turret_angle: float
var turret_dir: Vector2

@export_category("General stats")
@export var reload_time = 1.5
@export var movement_speed = 5

@export_category("Bot stats")
@export var target_shoot_angle = 5
@export var dist_to_target_stop = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_spawn_pos = get_node(bullet_spawn_path)
	turret_node = get_node(turret_path)
	
	if prespawned:
		setup(self, playerId)
	
	PlayerManager.player_left.connect(_on_player_disconnect)

func setup(sp: Node3D, playerId: int):
	playerId = playerId
	var pos = Vector3(sp.position.x, 0.0, sp.position.z)
	position = pos
	
	if(playerId >= -1):
		input = DeviceInput.new(PlayerManager.get_player_device(playerId))
		add_to_group("player")
		EntityManager.player_tanks.append(self)
	else:
		is_bot = true
		add_to_group("enemy")
		EntityManager.enemy_tanks.append(self)
	
	setup_done = true

var forward: Vector3

func _exit_tree():
	if(playerId >= -1):
		EntityManager.player_tanks.erase(self)
	else:
		EntityManager.enemy_tanks.erase(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !setup_done:
		return
	var input_dict: Dictionary
	if is_bot:
		input_dict = get_bot_input()
	else:
		input_dict = get_player_input()
		
	var shooting: bool = input_dict["shot"]
	if shooting:
		shoot()
	
func _integrate_forces(state):
	if !setup_done:
		return
	
	forward = global_transform.basis.z
	
	var input_dict: Dictionary
	if is_bot:
		input_dict = get_bot_input()
	else:
		input_dict = get_player_input()
	
	var fwd = input_dict["fwd"]
	var rot = input_dict["rot"]
	var look = input_dict["look"]
	
	#position = position + forward * fwd * movement_speed * delta
	var dir = (forward * fwd).normalized()
	var accel = dir * movement_speed * abs(fwd)
	linear_velocity += accel * state.get_step()
	#rotate_y(deg_to_rad(rot))
	#linear_velocity *= 0.8
	
	var rotation_amount = deg_to_rad(rot) * state.get_step() *50
	rotate_y(rotation_amount)	
	
	var angle = atan2(look.x, -look.y) + deg_to_rad(-90)
	
	turret_node.global_rotation = Quaternion(Vector3.UP, angle).get_euler()
	turret_angle = angle
	var t_dir = turret_node.global_transform.basis.z
	turret_dir = Vector2(t_dir.z, t_dir.x)
	
func shoot():
	if is_shot_cd:
		return
	
	is_shot_cd = true
	shot_timer.start(reload_time)
	
	var bullet = bullet_scene.instantiate()
	bullet.setup(bullet_spawn_pos.global_transform.rotated_local(Vector3.RIGHT,deg_to_rad(90)), self)
	get_tree().root.add_child(bullet)


func _on_player_disconnect(player: int):
	if player == playerId:
		queue_free()

func _on_shot_timer_timeout():
	is_shot_cd = false

func get_player_input() -> Dictionary:
	var input_dict: Dictionary
	var fwd = input.get_axis("move_forward","move_backwards")
	var rot = input.get_axis("turn_right","turn_left")
	var look = input.get_vector("look_left", "look_right", "look_down", "look_up").normalized()
	var shot = input.is_action_pressed("shot")
	input_dict = {
		fwd = fwd,
		rot = rot,
		look = look,
		shot = shot
	}
	return input_dict


func get_bot_input() -> Dictionary:
	
	var targetPos: Vector3 = get_target()
	var targetPos2D = Vector2(targetPos.x, targetPos.z)
	
	agent.target_position = targetPos
	agent.debug_enabled = true
	var current_pos = global_position
	var current_pos2D = Vector2(current_pos.x, current_pos.z)
	var next_pos = agent.get_next_path_position()
	var dir = (next_pos - current_pos).normalized()
	var dir2D = Vector2(dir.x, dir.z)
	var forward2D = Vector2(forward.x, forward.z)
	var angle = forward2D.angle_to(dir2D)
	var dAng = forward2D.dot(dir2D)
	var fwd = clampf(dAng,-1,1)
	#var rng = RandomNumberGenerator.new()
	var target_look_dir = turret_dir
	
	if playerVisible(targetPos):
		#print("player visible")
		target_look_dir = (targetPos2D - current_pos2D).normalized() * Vector2(1,-1)
		var t_angle = abs(turret_dir.angle_to(target_look_dir))
		if(t_angle < deg_to_rad(target_shoot_angle)):
			shoot()
		
		if current_pos2D.distance_to(targetPos2D) < dist_to_target_stop:
			fwd = 0
		
	
	var input_dict: Dictionary
	input_dict = {
		fwd = fwd,
		rot = clampf(angle,-1,1),
		look = target_look_dir,
		shot = false,
	}
	return input_dict

func playerVisible(target: Vector3) -> bool:
	var vis = false
	# Define the ray start and end points
	var from = get_global_transform().origin
	var to = target

	# Perform the raycast
	var space_state = get_world_3d().direct_space_state
	var param: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(param)
	if result:
		#print(result)
		if result.collider.is_in_group("player"):
			vis = true
	return vis

func get_target() -> Vector3:
	var pl:Node3D = EntityManager.get_closest_player(global_position)
	if pl != null:
		return pl.global_position
	return global_position

func calc_angle(vec1: Vector2, vec2: Vector2) -> float:
	# Calculate the dot product
	var dot_product = vec1.dot(vec2)

	# Calculate the magnitudes (lengths) of the vectors
	var magnitude_vec1 = vec1.length()
	var magnitude_vec2 = vec2.length()

	# Calculate the cosine of the angle
	var cos_angle = dot_product / (magnitude_vec1 * magnitude_vec2)

	# Calculate the angle in radians
	var angle_radians = acos(cos_angle)
	return angle_radians
