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
	
	# Open the top cover of the book
	var left_pivot := get_node_or_null("LeftCoverPivot")
	if left_pivot:
		var tween := create_tween()
		tween.tween_property(left_pivot, "rotation_degrees:z", -110.0, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	super.interact()
