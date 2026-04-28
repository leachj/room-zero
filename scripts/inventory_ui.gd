## Inventory UI — displays collected items as clickable slots.
extends HBoxContainer

const SLOT_SIZE := Vector2(64, 64)

var _slot_scene_cache: Dictionary = {}


func _ready() -> void:
	Inventory.item_added.connect(_on_item_added)
	Inventory.item_removed.connect(_on_item_removed)
	Inventory.item_deselected.connect(_on_item_deselected)


func _on_item_added(item: ItemData) -> void:
	var slot := _create_slot(item)
	add_child(slot)


func _on_item_removed(item: ItemData) -> void:
	for child in get_children():
		if child.has_meta("item_id") and child.get_meta("item_id") == item.id:
			child.queue_free()
			break


func _on_item_deselected() -> void:
	for child in get_children():
		if child is Button:
			child.button_pressed = false


func _create_slot(item: ItemData) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = SLOT_SIZE
	btn.toggle_mode = true
	btn.tooltip_text = item.display_name + "\n" + item.description
	btn.set_meta("item_id", item.id)
	btn.set_meta("item_data", item)
	
	if item.icon:
		var tex_rect := TextureRect.new()
		tex_rect.texture = item.icon
		tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex_rect.custom_minimum_size = SLOT_SIZE * 0.8
		tex_rect.anchors_preset = Control.PRESET_CENTER
		btn.add_child(tex_rect)
	else:
		btn.text = item.display_name.substr(0, 3).to_upper()
	
	btn.toggled.connect(func(pressed: bool):
		if pressed:
			Inventory.select_item(item)
		else:
			Inventory.deselect()
	)
	
	return btn
