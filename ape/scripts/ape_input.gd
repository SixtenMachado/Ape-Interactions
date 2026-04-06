extends Node
class_name PlayerInput

var movement: Vector3 = Vector3.ZERO
var jump : bool = false
var ragdoll : bool = false

@export var mouse_sensitivity: float = 1.0
var mouse_rotation: Vector2 = Vector2.ZERO
var look_angle: Vector2 = Vector2.ZERO
var override_mouse: bool = false

func _ready():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return

	var move_x = Input.get_axis("move_left", "move_right")
	var move_z = Input.get_axis("move_forward", "move_back")
	movement = Vector3(move_x, 0, move_z)
	
	jump = Input.is_action_pressed("jump")
	
	ragdoll = Input.is_action_pressed("ragdoll")
	
	# don't move the camera when the mouse is "released" with ESC
	if override_mouse:
		look_angle = Vector2.ZERO
		mouse_rotation = Vector2.ZERO
	else:
		look_angle = Vector2(-mouse_rotation.y, -mouse_rotation.x)
		mouse_rotation = Vector2.ZERO
		

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return

	if event is InputEventMouseMotion:
		mouse_rotation.y += event.relative.x * mouse_sensitivity
		mouse_rotation.x += event.relative.y * mouse_sensitivity

	if event.is_action_pressed("escape"):
		if override_mouse:
			override_mouse = false
			Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			override_mouse = true
