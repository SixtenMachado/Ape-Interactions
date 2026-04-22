extends Node
class_name PlayerInput

var movement: Vector3 = Vector3.ZERO
var jump : bool = false
var ragdoll : bool = false
var hand_right : bool = false
var hand_left : bool = false
var crouch : bool = false
var mic : bool = false

var enable_funny_jump : bool = false

@export var mouse_sensitivity: float = 1.0
var mouse_rotation: Vector2 = Vector2.ZERO
var look_angle: Vector2 = Vector2.ZERO
var override_mouse: bool = false

func _ready():
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return

	var move_x = Input.get_axis("move_left", "move_right")
	var move_z = Input.get_axis("move_forward", "move_back")
	movement = Vector3(move_x, 0, move_z)
	
	jump = Input.is_action_pressed("jump")
	crouch = Input.is_action_pressed("crouch")
	ragdoll = Input.is_action_pressed("ragdoll")
	hand_right = Input.is_action_pressed("hand_right")
	hand_left = Input.is_action_pressed("hand_left")
	mic = Input.is_action_pressed("mic")
	
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
	
#	DEV COMMANDS
	if event.is_action_pressed("escape_mouse"):
		if override_mouse:
			override_mouse = false
			Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			override_mouse = true
	
	if event.is_action_pressed("reset_position"):
		get_parent().global_position = Vector3(0,5,0)
		get_parent().velocity = Vector3.ZERO
	
	if event.is_action_pressed("enable_funny_jump"):
		enable_funny_jump = !enable_funny_jump
		print("funny jump enabled: ", enable_funny_jump)
