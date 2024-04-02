@tool
extends EditorScenePostImport
var dds : MeshInstance3D
#--------------
#--Import LOD--
#--------------

var lod = true
var lod1 = 10.0
var lod2 = 30.0
var lod3 = 100.0

#-------------
#--Collision--
#-------------

var collision = false



func _post_import(scene):
	iterate(scene)
	return scene 

func iterate(scene):
	if scene != null:
		for child in scene.get_children():
			if child.name.ends_with("_lod_0") and lod == true:
				child.set_visibility_range_begin(0.0)
				child.set_visibility_range_end(lod1)
			if child.name.ends_with("_lod_1") and lod == true:
				child.set_visibility_range_begin(lod1)
				child.set_visibility_range_end(lod2)
			if child.name.ends_with("_lod_2") and lod == true:
				child.set_visibility_range_begin(lod2)
				child.set_visibility_range_end(lod3)
			#Collision
			if collision == true:
				child.create_convex_collision(collision)
			else:
				#child.create_convex_collision(collision)
				pass
				


