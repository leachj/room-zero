## GameState — Autoload singleton
## Tracks puzzle/object states and win condition.
extends Node

signal state_changed(key: String, value: Variant)
signal room_escaped

var _state: Dictionary = {}


func set_state(key: String, value: Variant) -> void:
	_state[key] = value
	state_changed.emit(key, value)
	_check_win_condition()


func get_state(key: String, default: Variant = null) -> Variant:
	return _state.get(key, default)


func is_true(key: String) -> bool:
	return _state.get(key, false) == true


func _check_win_condition() -> void:
	if is_true("door_unlocked"):
		room_escaped.emit()
