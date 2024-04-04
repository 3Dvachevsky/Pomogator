@tool
extends PanelContainer
#---Other-Scripts---#
@onready var select_file = $VBoxContainer/SelectFile
@onready var reimport_settings = $VBoxContainer/ReimportSettings

#---Bot-Pannel-Buttons---#
@onready var reimport_button = $VBoxContainer/BotPanel/HBoxContainer/ReimportButton
@onready var get_setting_button = $VBoxContainer/BotPanel/HBoxContainer/GetSettingButton
@onready var reset_button = $VBoxContainer/BotPanel/HBoxContainer/ResetButton
#---VARE---#
var file_path: String
var lod_distances: Array[float]
var generate_lod: bool
var apply_distance: bool
var collision: bool
var scene_root: String

func _ready():
	reimport_button.pressed.connect(_reimport_button)
	get_setting_button.pressed.connect(_get_setting_button)
	reset_button.pressed.connect(_reset_button)
	pass

func _update_var(distances: Array[float], lod: bool, dist: bool, coll: bool, root: String):
	lod_distances = distances
	generate_lod = lod
	apply_distance = dist
	scene_root = root
	collision = coll

func _reimport_button():
	var file: PackedScene = load(file_path)
	var scene: Node3D = file.instantiate()
	var config = ConfigFile.new()
	config.load(file_path + ".import")
	var subresources: Dictionary = config.get_value("params", "_subresources")
	var subresources_nodes: Dictionary
	
	#if subresources.has("node"):
		#subresources_nodes = subresources["node"].duplicate()
	
	if collision:
		config.set_value("params", "import_script/path", "res://addons/pomogator/post_import.gd")
	else:
		config.set_value("params", "import_script/path", "")
	
	if apply_distance:
		var begin: float
		var end: float
		for child in scene.get_children():
			if child.name.contains("lod_0"):
				begin = 0.0
				end = lod_distances[0]
			elif child.name.contains("lod_1"):
				begin = lod_distances[0]
				end = lod_distances[1]
			elif child.name.contains("lod_2"):
				begin = lod_distances[1]
				end = lod_distances[2]
				
			if child is MeshInstance3D:
				subresources_nodes["PATH:" + child.name] = {"mesh_instance/visibility_range_begin": begin, "mesh_instance/visibility_range_end": end}
			
	if !subresources.has("nodes"):
		subresources["nodes"] = {}
		
	subresources["nodes"].clear()
	subresources["nodes"] = subresources_nodes
	
	config.set_value("params", "_subresources", subresources)
	config.set_value("params", "meshes/generate_lods", generate_lod)
	config.set_value("params", "nodes/root_type", scene_root)
	config.save(file_path + ".import")
	
	EditorInterface.get_resource_filesystem().reimport_files([file_path])
	pass

func _get_setting_button():
	return
	var file: PackedScene = load(file_path)
	var scene: Node3D = file.instantiate()
	var config = ConfigFile.new()
	config.load(file_path + ".import")
	
	for child in scene.get_children():
		#lod_distances[0] = child.get_visibility_range_begin
		pass
	
	
	generate_lod = config.get_value("params", "meshes/generate_lods")
	
	reimport_settings._get_setting(lod_distances, generate_lod, apply_distance)
	pass

func _reset_button():
	select_file._reset()
	reimport_settings._reset()

func _process(delta):
	pass

func _set_path(path: String):
	file_path = path



