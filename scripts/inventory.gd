## Inventory — Autoload singleton
## Manages collected items and selection state.
extends Node

signal item_added(item: ItemData)
signal item_removed(item: ItemData)
signal item_selected(item: ItemData)
signal item_deselected

var items: Array[ItemData] = []
var selected_item: ItemData = null


func add_item(item: ItemData) -> void:
	if not items.has(item):
		items.append(item)
		item_added.emit(item)


func remove_item(item: ItemData) -> void:
	var idx := items.find(item)
	if idx >= 0:
		items.remove_at(idx)
		if selected_item == item:
			deselect()
		item_removed.emit(item)


func has_item(item_id: String) -> bool:
	for item in items:
		if item.id == item_id:
			return true
	return false


func select_item(item: ItemData) -> void:
	selected_item = item
	item_selected.emit(item)


func deselect() -> void:
	selected_item = null
	item_deselected.emit()


func get_selected() -> ItemData:
	return selected_item
