extends Node3D

var levelfolderPath = "res://Levels/"
var main_menu_path = "res://MainMenu.tscn"
var currentLevelIndex = -1
var all_level_paths: Array[String]
var level_count: int
var is_level_active: bool
var timer: float = -1
var timer_active = false

@onready var music_player_scene = preload("res://music_player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_all_levels()
	var mp = music_player_scene.instantiate()
	self.add_child(mp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_active:
		if timer > 0:
			timer -= delta
		else:
			timer_active = false
			load_level(currentLevelIndex )
	pass

func load_level(idx, delay = 0):
	if delay > 0:
		if timer_active:
			return
		currentLevelIndex = idx
		timer_active = true
		timer = delay
		return
	
	timer_active = false
	timer = -1
	if idx >= level_count:
		print("Last level, can't load next")
		return
		
		
	currentLevelIndex = idx
	EntityManager.clear()
	if idx < 0:
		is_level_active = false
		get_tree().change_scene_to_file(main_menu_path)
		return
	else:
		var path = all_level_paths[currentLevelIndex]
		get_tree().change_scene_to_file(path)


func get_all_levels():
	var dir = DirAccess.open(levelfolderPath)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			print("File name: ", file_name)  # Debugging release builds
			if file_name.ends_with("tscn"):
				all_level_paths.push_back(levelfolderPath + file_name)
			file_name = dir.get_next()
		level_count = all_level_paths.size()

func load_next_level(delay):
	load_level(currentLevelIndex+1, delay)

func load_current_level(delay):
	load_level(currentLevelIndex, delay)

func finished_loading():
	print("finished loading level: ", currentLevelIndex)
	EntityManager.instantiate_entities()
	is_level_active = true
