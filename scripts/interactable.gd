## Base class for all interactable objects in the room.
class_name Interactable
extends StaticBody3D

signal interacted
signal used_item(item: ItemData)

@export var interaction_tag: String = ""
@export var highlight_color: Color = Color(1.0, 1.0, 0.5, 1.0)
@export var prompt_text: String = "Interact"

var _original_materials: Dictionary = {}
var _is_highlighted: bool = false


func _ready() -> void:
	collision_layer = 2  # interactable layer
	input_ray_pickable = true
	_cache_materials()


func _cache_materials() -> void:
	for child in get_children():
		if child is MeshInstance3D or child is CSGShape3D:
			if child is MeshInstance3D and child.get_surface_override_material(0):
				_original_materials[child] = child.get_surface_override_material(0).duplicate()


func highlight() -> void:
	if _is_highlighted:
		return
	_is_highlighted = true
	for child in get_children():
		if child is MeshInstance3D:
			var mat := child.get_surface_override_material(0)
			if mat is StandardMaterial3D:
				mat = mat.duplicate()
				mat.emission_enabled = true
				mat.emission = highlight_color
				mat.emission_energy_multiplier = 0.3
				child.set_surface_override_material(0, mat)


func unhighlight() -> void:
	if not _is_highlighted:
		return
	_is_highlighted = false
	for child in get_children():
		if child is MeshInstance3D:
			if _original_materials.has(child):
				child.set_surface_override_material(0, _original_materials[child].duplicate())


func interact() -> void:
	interacted.emit()


func use_item(item: ItemData) -> bool:
	if interaction_tag in item.usable_on_tags:
		used_item.emit(item)
		return true
	return false
