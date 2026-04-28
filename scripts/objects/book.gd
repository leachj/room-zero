## Book — hides a note underneath. Click to reveal.
extends Interactable

@export var note_item: ItemData

var _revealed: bool = false


func _ready() -> void:
	super._ready()
	prompt_text = "Look at book"


func interact() -> void:
	if _revealed:
		return
	_revealed = true
	GameState.set_state("note_found", true)
	
	# Animate book moving aside
	var tween := create_tween()
	tween.tween_property(self, "position:x", position.x + 0.3, 0.4).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees:z", -15.0, 0.3)
	
	super.interact()
