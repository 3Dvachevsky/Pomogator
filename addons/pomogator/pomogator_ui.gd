@tool
extends Control

@export var select_button: Button
@export var file_path: LineEdit
@export var scene_root: OptionButton
@export var generate_lod: CheckButton

@export var custom_lod: CheckButton
@export var checkbox_lod0: CheckBox
@export var suffix_lod0: LineEdit
@export var spinbox_lod0: SpinBox
@export var checkbox_lod1: CheckBox
@export var suffix_lod1: LineEdit
@export var spinbox_lod1: SpinBox
@export var checkbox_lod2: CheckBox
@export var suffix_lod2: LineEdit
@export var spinbox_lod2: SpinBox

@export var shadow_lod: CheckButton
@export var suffix_shadow_lod: LineEdit
@export var spinbox_shadowlod: SpinBox

@export var reimport: Button

var path: String

func _ready():
	select_button.pressed.connect(_select_file)
	generate_lod.pressed.connect(_generate_lod)
	custom_lod.pressed.connect(_custom_lod)
	reimport.pressed.connect(_reimport)

func _select_file():
	path = EditorInterface.get_current_path()
	if path.ends_with(".glb"):
		file_path.text = path
	else:
		file_path.text = ""
	_get_val()
	
func _get_val():
	var suff: Array[String]
	var dist: Array[SpinBox]
	
	suff.append(suffix_lod0.text)
	suff.append(suffix_lod1.text)
	suff.append(suffix_lod2.text)
	
	dist.append(spinbox_lod0)
	dist.append(spinbox_lod1)
	dist.append(spinbox_lod2)
	
	var file: PackedScene = load(path)
	var scene: Node3D = file.instantiate()
	var config = ConfigFile.new()
	config.load(path + ".import")
	if config.get_value("params", "_subresources") != {}:
		var dic: Dictionary = config.get_value("params", "_subresources").get("nodes")
		for child in scene.get_children():
			for i in suff.size():
				if child.name.contains(suff[i]):
					dist[i].value = dic.get("PATH:" + child.name).get("mesh_instance/visibility_range_end")

func _generate_lod():
	if generate_lod.button_pressed:
		custom_lod.button_pressed = false

func _custom_lod():
	if custom_lod.button_pressed:
		generate_lod.button_pressed = false

func _reimport():
	var file: PackedScene = load(path)
	var scene: Node3D = file.instantiate()
	var config = ConfigFile.new()
	config.load(path + ".import")
	var subresources: Dictionary = config.get_value("params", "_subresources")
	var subresources_nodes: Dictionary
	
	if custom_lod.button_pressed:
		var begin: float
		var end: float
		for child in scene.get_children():
			if child.name.contains(suffix_lod0.text) and checkbox_lod0.button_pressed:
				begin = 0.0
				end = spinbox_lod0.value
			elif child.name.contains(suffix_lod1.text) and checkbox_lod1.button_pressed:
				begin = spinbox_lod0.value
				end = spinbox_lod1.value
			elif child.name.contains(suffix_lod2.text) and checkbox_lod2.button_pressed:
				begin = spinbox_lod1.value
				end = spinbox_lod2.value
			
			if child is MeshInstance3D:
				subresources_nodes["PATH:" + child.name] = {"mesh_instance/visibility_range_begin": begin, "mesh_instance/visibility_range_end": end}
			
			if shadow_lod.button_pressed:
				if child.name.contains(suffix_shadow_lod.text):
					subresources_nodes["PATH:" + child.name] = {"mesh_instance/visibility_range_begin": 0.0, "mesh_instance/visibility_range_end": spinbox_shadowlod.value}
				else:
					subresources_nodes["PATH:" + child.name].merge({"mesh_instance/cast_shadow": 0})
	
	if !subresources.has("nodes"):
		subresources["nodes"] = {}
		
	subresources["nodes"].clear()
	subresources["nodes"] = subresources_nodes
	
	config.set_value("params", "_subresources", subresources)
	config.set_value("params", "meshes/generate_lods", generate_lod.button_pressed)
	config.set_value("params", "nodes/root_type", scene_root.text)
	config.save(path + ".import")
	
	EditorInterface.get_resource_filesystem().reimport_files([path])
