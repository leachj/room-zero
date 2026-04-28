## Game Manager
## Top-level controller for the room scene. Handles UI messages and win state.
extends Node

@onready var message_label: Label = %MessageLabel
@onready var keypad_panel: Control = %KeypadPanel

var _message_timer: float = 0.0
var _safe: Node = null


func _ready() -> void:
	GameState.room_escaped.connect(_on_room_escaped)
	GameState.state_changed.connect(_on_state_changed)
	keypad_panel.visible = false
	keypad_panel.code_entered.connect(_on_code_entered)
	message_label.text = ""


func _process(delta: float) -> void:
	if _message_timer > 0:
		_message_timer -= delta
		if _message_timer <= 0:
			message_label.text = ""


func show_message(text: String, duration: float = 3.0) -> void:
	message_label.text = text
	_message_timer = duration


func show_keypad() -> void:
	_safe = get_tree().get_first_node_in_group("safe")
	keypad_panel.visible = true


func hide_keypad() -> void:
	keypad_panel.visible = false


func _on_room_escaped() -> void:
	show_message("You escaped Room Zero! Congratulations!", 10.0)


func _on_code_entered(code: String) -> void:
	if _safe and _safe.has_method("try_code"):
		var success: bool = _safe.try_code(code)
		keypad_panel.show_feedback(success)
		if success:
			hide_keypad()
	else:
		keypad_panel.show_feedback(false)


func _on_state_changed(key: String, value: Variant) -> void:
	match key:
		"note_found":
			show_message("You found a torn note... it reads: '7 _ _ 3'")
		"drawer_opened":
			show_message("Inside the drawer you find a scrap of paper: '_ 2 8 _'")
		"safe_opened":
			show_message("The safe clicks open!")
		"key_collected":
			show_message("You picked up a rusty key.")
		"door_unlocked":
			pass  # handled by room_escaped signal
