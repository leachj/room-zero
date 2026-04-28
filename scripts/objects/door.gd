## Door — the exit. Unlocked with the key item.
extends Interactable

var _is_locked: bool = true


func _ready() -> void:
	super._ready()
	prompt_text = "Try door"
	interaction_tag = "door"


func interact() -> void:
	if _is_locked:
		var manager := get_tree().get_first_node_in_group("game_manager")
		if manager and manager.has_method("show_message"):
			manager.show_message("The door is locked. You need a key.")
	else:
		_open_door()
	super.interact()


func use_item(item: ItemData) -> bool:
	if item.id == "key" and _is_locked:
		_unlock()
		return true
	
	var manager := get_tree().get_first_node_in_group("game_manager")
	if manager and manager.has_method("show_message"):
		manager.show_message("That doesn't work on the door.")
	return false


func _unlock() -> void:
	_is_locked = false
	GameState.set_state("door_unlocked", true)
	_open_door()


func _open_door() -> void:
	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees:y", -90.0, 0.8).set_ease(Tween.EASE_IN_OUT)
