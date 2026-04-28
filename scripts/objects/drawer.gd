## Drawer — opens on interact to reveal a clue.
extends Interactable

var _is_open: bool = false


func _ready() -> void:
	super._ready()
	prompt_text = "Open drawer"


func interact() -> void:
	if _is_open:
		return
	_is_open = true
	GameState.set_state("drawer_opened", true)
	
	# Slide drawer open
	var tween := create_tween()
	tween.tween_property(self, "position:z", position.z + 0.4, 0.5).set_ease(Tween.EASE_OUT)
	
	super.interact()
