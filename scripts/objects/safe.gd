## Safe — requires a 4-digit code to open. Contains the key.
extends Interactable

@export var correct_code: String = "7283"
@export var key_item: ItemData

var _is_open: bool = false
var _game_manager: Node


func _ready() -> void:
	super._ready()
	prompt_text = "Examine safe"
	interaction_tag = "safe"
	_game_manager = get_tree().get_first_node_in_group("game_manager")


func interact() -> void:
	if _is_open:
		return
	if _game_manager and _game_manager.has_method("show_keypad"):
		_game_manager.show_keypad()
	super.interact()


func try_code(code: String) -> bool:
	if code == correct_code:
		_open_safe()
		return true
	return false


func _open_safe() -> void:
	_is_open = true
	GameState.set_state("safe_opened", true)
	
	# Animate safe door opening
	var door_mesh := get_node_or_null("SafeDoor")
	if door_mesh:
		var tween := create_tween()
		tween.tween_property(door_mesh, "rotation_degrees:y", -110.0, 0.6).set_ease(Tween.EASE_OUT)
	
	# Grant key after a short delay
	await get_tree().create_timer(0.8).timeout
	if key_item:
		Inventory.add_item(key_item)
		GameState.set_state("key_collected", true)
