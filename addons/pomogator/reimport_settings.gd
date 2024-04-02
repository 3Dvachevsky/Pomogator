@tool
extends PanelContainer

@onready var distance_lod_0 = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/DistanceLod0
@onready var distance_lod_1 = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/DistanceLod1
@onready var distance_lod_2 = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/DistanceLod2
var buttons_distances: Array[SpinBox]

@onready var scene_root = $VBoxContainer/HBoxContainer/VBoxContainer/SceneRoot

@onready var generate_lod = $VBoxContainer/HBoxContainer/VBoxContainer/GenerateLod
@onready var apply_lod_distances = $VBoxContainer/HBoxContainer/VBoxContainer/ApplyLodDistances

@onready var pomogator = $"../.."

func _ready():
	distance_lod_0.value_changed.connect(_update)
	distance_lod_1.value_changed.connect(_update)
	distance_lod_2.value_changed.connect(_update)
	generate_lod.toggled.connect(_update)
	apply_lod_distances.toggled.connect(_update)
	scene_root.item_selected.connect(_update)
	buttons_distances = [distance_lod_0, distance_lod_1, distance_lod_2]
	_update(0)

func _update(value):
	var lod_distances: Array[float] = [distance_lod_0.value, distance_lod_1.value, distance_lod_2.value]
	pomogator._update_var(lod_distances, generate_lod.button_pressed, apply_lod_distances.button_pressed, scene_root.text)

func _get_setting(distances: Array[float], lod: bool, dist: bool):
	for i in buttons_distances.size():
		buttons_distances[i].value = distances[i]
	generate_lod.button_pressed = lod
	apply_lod_distances.button_pressed = dist
