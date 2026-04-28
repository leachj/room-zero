## Player Controller
## Handles click-to-move on the floor plane and interaction with objects.
extends CharacterBody3D

@export var move_speed: float = 4.0
@export var arrival_distance: float = 0.15
@export var interact_range: float = 1.0

var _target_position: Vector3
var _is_moving: bool = false
var _hovered_interactable: Interactable = null
var _pending_interactable: Interactable = null
var _camera: Camera3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	_camera = get_viewport().get_camera_3d()
	_target_position = global_position
	navigation_agent.path_desired_distance = arrival_distance
	navigation_agent.target_desired_distance = arrival_distance


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_update_hover(event.position)
	
	if event.is_action_pressed("interact"):
		_handle_click(event as InputEventMouseButton)


func _update_hover(screen_pos: Vector2) -> void:
	var result := _raycast_from_screen(screen_pos, 2)  # interactable layer
	
	if _hovered_interactable:
		_hovered_interactable.unhighlight()
		_hovered_interactable = null
	
	if result and result.collider is Interactable:
		_hovered_interactable = result.collider as Interactable
		_hovered_interactable.highlight()


func _handle_click(event: InputEventMouseButton) -> void:
	if not event:
		return
	
	# Priority 1: Check for interactable
	var interact_result := _raycast_from_screen(event.position, 2)
	if interact_result:
		print("[Click] Hit: ", interact_result.collider.name, " is Interactable: ", interact_result.collider is Interactable)
	else:
		print("[Click] Raycast layer 2 hit nothing at ", event.position)
	
	if interact_result and interact_result.collider is Interactable:
		var target: Interactable = interact_result.collider
		if _is_within_range(target):
			_do_interact(target)
		else:
			# Walk to the object, then interact on arrival
			_pending_interactable = target
			var dir := (global_position - target.global_position).normalized()
			_target_position = target.global_position + dir * (interact_range * 0.7)
			_target_position.y = global_position.y
			navigation_agent.target_position = _target_position
			_is_moving = true
		return
	
	# Priority 2: Move to floor position
	var floor_result := _raycast_from_screen(event.position, 4)  # floor layer (bit 3)
	if floor_result:
		_pending_interactable = null
		_target_position = floor_result.position
		navigation_agent.target_position = _target_position
		_is_moving = true


func _physics_process(delta: float) -> void:
	if not _is_moving:
		return
	
	if navigation_agent.is_navigation_finished():
		_is_moving = false
		velocity = Vector3.ZERO
		if _pending_interactable and _is_within_range(_pending_interactable):
			_do_interact(_pending_interactable)
			_pending_interactable = null
		return
	
	var next_pos := navigation_agent.get_next_path_position()
	var direction := (next_pos - global_position).normalized()
	direction.y = 0
	
	velocity = direction * move_speed
	move_and_slide()


func _raycast_from_screen(screen_pos: Vector2, layer_mask: int) -> Dictionary:
	var from := _camera.project_ray_origin(screen_pos)
	var to := from + _camera.project_ray_normal(screen_pos) * 100.0
	
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = layer_mask
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = [get_rid()]
	
	var space_state := get_world_3d().direct_space_state
	return space_state.intersect_ray(query)


func _is_within_range(target: Node3D) -> bool:
	var dist := global_position.distance_to(target.global_position)
	return dist <= interact_range


func _do_interact(target: Interactable) -> void:
	var selected := Inventory.get_selected()
	if selected:
		if target.use_item(selected):
			Inventory.remove_item(selected)
		Inventory.deselect()
	else:
		target.interact()
