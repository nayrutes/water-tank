extends RigidBody3D

var is_shot_cd: bool = false

@onready var shot_timer: Timer = $ShotTimer
@onready var bullet_scene = preload("res://bullet.tscn")
@export var bullet_spawn_path: NodePath
var bullet_spawn_pos: Node3D

@export var turret_path: NodePath
var turret_node: Node3D

@export var playerId = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_spawn_pos = get_node(bullet_spawn_path)
	turret_node = get_node(turret_path)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var fwd = MultiplayerInput.get_axis(playerId, "move_forward","move_backwards")
	var forward = global_transform.basis.z
	position = position + forward * fwd * 0.1
	var rot = MultiplayerInput.get_axis(playerId, "turn_right","turn_left")
	rotate_y(deg_to_rad(rot))
	
	
	var look = MultiplayerInput.get_vector(playerId, "look_left", "look_right", "look_down", "look_up").normalized()
	var angle = atan2(look.x, -look.y) + deg_to_rad(-90)
	
	turret_node.global_rotation = Quaternion(Vector3.UP, angle).get_euler()
	
	
	
	if MultiplayerInput.is_action_pressed(playerId, "shot") and not is_shot_cd:
		shoot()
		is_shot_cd = true
		shot_timer.start(0.2)
	pass
	
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.setup(bullet_spawn_pos.global_transform.rotated_local(Vector3.RIGHT,deg_to_rad(90)), self)
	get_tree().root.add_child(bullet)

func _on_shot_timer_timeout():
	is_shot_cd = false
