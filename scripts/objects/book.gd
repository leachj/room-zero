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
	
	# Open both covers outward from the spine
	var left_pivot := get_node_or_null("LeftCoverPivot")
	var right_pivot := get_node_or_null("RightCoverPivot")
	
	var tween := create_tween().set_parallel(true)
	if left_pivot:
		tween.tween_property(left_pivot, "rotation_degrees:z", -110.0, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	if right_pivot:
		tween.tween_property(right_pivot, "rotation_degrees:z", 110.0, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	super.interact()
