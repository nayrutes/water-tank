extends Node3D

var levelfolderPath = "res://Levels/"
var currentLevelIndex = 0
var all_level_paths: Array[String]
var level_count: int
var is_level_active: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	get_all_levels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_level(idx):
	if idx >= level_count:
		print("Last level, can't load next")
		return
	
	EntityManager.clear()
	currentLevelIndex = idx
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

func load_next_level():
	load_level(currentLevelIndex+1)

func load_current_level():
	load_level(currentLevelIndex)

func finished_loading():
	print("finished loading level: ", currentLevelIndex)
	EntityManager.instantiate_entities()
	is_level_active = true
