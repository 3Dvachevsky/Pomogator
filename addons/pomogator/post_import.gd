@tool
extends EditorScenePostImport
var dds : MeshInstance3D


func _post_import(scene):
	iterate(scene)
	return scene 

func iterate(scene: Node3D):
	if scene != null:
		for child: MeshInstance3D in scene.get_children():
			if child.name.contains("_collision"):
				var name: String = child.name
				child.create_convex_collision()
				var col = child.get_child(0).get_child(0)
				col.reparent(scene)
				col.transform = child.transform
				child.free()
				col.name = name
	

