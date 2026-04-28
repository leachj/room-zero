## Keypad UI — 4-digit code entry for the safe.
extends Control

signal code_entered(code: String)

@onready var display_label: Label = $PanelContainer/VBoxContainer/Display
@onready var feedback_label: Label = $PanelContainer/VBoxContainer/Feedback

var _current_code: String = ""
var _max_digits: int = 4


func _ready() -> void:
	_update_display()
	feedback_label.text = ""


func _on_digit_pressed(digit: int) -> void:
	if _current_code.length() >= _max_digits:
		return
	_current_code += str(digit)
	_update_display()


func _on_clear_pressed() -> void:
	_current_code = ""
	feedback_label.text = ""
	_update_display()


func _on_enter_pressed() -> void:
	if _current_code.length() != _max_digits:
		feedback_label.text = "Enter 4 digits"
		return
	code_entered.emit(_current_code)


func _on_close_pressed() -> void:
	visible = false
	_current_code = ""
	_update_display()


func show_feedback(success: bool) -> void:
	if success:
		feedback_label.text = "CORRECT!"
		feedback_label.modulate = Color.GREEN
		await get_tree().create_timer(1.0).timeout
		visible = false
	else:
		feedback_label.text = "WRONG CODE"
		feedback_label.modulate = Color.RED
		_current_code = ""
		_update_display()


func _update_display() -> void:
	var display := ""
	for i in range(_max_digits):
		if i < _current_code.length():
			display += _current_code[i]
		else:
			display += "_"
		if i < _max_digits - 1:
			display += " "
	display_label.text = display
