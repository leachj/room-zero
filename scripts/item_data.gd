## Item Resource
## Defines an inventory item's properties.
class_name ItemData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var usable_on_tags: PackedStringArray = []
