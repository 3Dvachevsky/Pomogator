@tool
extends PanelContainer

@onready var file_path = $SelectFileVBoxContainer/FilePathHBoxContainer/FilePath
@onready var select_button = $SelectFileVBoxContainer/FilePathHBoxContainer/SelectButton
@onready var pomogator = $"../.."

func _ready():
	select_button.pressed.connect(_select_file)

func _select_file():
	var path: String = EditorInterface.get_current_path()
	var file = load(path)
	if path.ends_with(".glb"):
		if file.get_class() == "PackedScene":
			file_path.text = path
			pomogator._set_path(path)
	else:
		file_path.text = ""

func _reset():
	file_path.text = ""
