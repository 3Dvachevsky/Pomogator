@tool
extends EditorPlugin

var interface 

const POMOGATOR = preload("res://addons/pomogator/icons/pomogator.svg")

func _enter_tree():
	interface = preload("res://addons/pomogator/pomogator.tscn").instantiate()
	EditorInterface.get_editor_main_screen().add_child(interface)
	interface.hide()

func _exit_tree():
	if interface:
		interface.queue_free()
		
func _has_main_screen():
	return true

func _get_plugin_name():
	return "Pomogator"
	
func _get_plugin_icon():
	return POMOGATOR
	
func _make_visible(visible):
	if interface:
		interface.visible = visible 
