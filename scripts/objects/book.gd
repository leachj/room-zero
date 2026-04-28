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
	
	# Animate book opening (rotate cover upward like opening a book)
	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees:x", -120.0, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	super.interact()
