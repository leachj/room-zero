## Camera Controller
## Right-click drag to pan the isometric camera. Scroll to zoom.
extends Camera3D

@export var pan_speed: float = 0.02
@export var zoom_speed: float = 0.5
@export var min_zoom: float = 4.0
@export var max_zoom: float = 16.0

var _is_dragging: bool = false
var _drag_start: Vector2 = Vector2.ZERO

# Camera's local right and forward vectors projected onto the XZ plane
var _pan_right: Vector3
var _pan_forward: Vector3


func _ready() -> void:
	_update_pan_vectors()


func _update_pan_vectors() -> void:
	# Get camera's local axes projected onto the XZ plane for intuitive panning
	_pan_right = global_transform.basis.x
	_pan_right.y = 0
	_pan_right = _pan_right.normalized()

	_pan_forward = global_transform.basis.y
	_pan_forward.y = 0
	_pan_forward = _pan_forward.normalized()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_RIGHT:
			_is_dragging = mb.pressed
			_drag_start = mb.position
			get_viewport().set_input_as_handled()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			size = clampf(size - zoom_speed, min_zoom, max_zoom)
			get_viewport().set_input_as_handled()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			size = clampf(size + zoom_speed, min_zoom, max_zoom)
			get_viewport().set_input_as_handled()

	if event is InputEventMouseMotion and _is_dragging:
		var motion := event as InputEventMouseMotion
		var delta := motion.relative
		global_position -= _pan_right * delta.x * pan_speed
		global_position += _pan_forward * delta.y * pan_speed
		get_viewport().set_input_as_handled()
