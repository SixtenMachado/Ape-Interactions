extends CharacterBody3D
class_name ApeBody

@export_category("Cool Ape Stats")
@export var speed := 4.0
@export var jump_strength := 5.0
@export var ground_rotation_speed := 20.0
@export var air_rotation_speed := 3.0

@export_category("Node Friends")
@export var input: PlayerInput
@export var camera: Camera3D
@export var look: Node3D
@export var model: Node3D
@export var state: PlayerState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting(&"physics/3d/default_gravity")
var adjusting_rotation : bool = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	print(get_multiplayer_authority(), " is my multiplayer authority")
	print(is_multiplayer_authority(), " am i multiplayer authority?")

func _ready():
	# Set spawn position
	position = Vector3(0, 4, 0)
	
	# Once we're spawned, set our camera
	await get_tree().process_frame
	if input.is_multiplayer_authority():
		camera.current = true
	

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
		
	if state.current_state == state.State.RAGDOLL:
		return
	
	if is_on_floor():
		# Ground-based jumping, for your ape pleasure
		if input.jump:
			velocity.y = jump_strength
	else: 
		# Add the gravity.
		velocity.y -= gravity * delta
	
	var adjusted_look_rotation := look.rotation.y + deg_to_rad(180)
	var rotation_delta := absf(angle_difference(model.rotation.y, adjusted_look_rotation))
	
	if adjusting_rotation:
		adjusting_rotation = rotation_delta > 0.1
	else:
		adjusting_rotation = rotation_delta > 2.4
		
	if velocity.length() > 0 or (input.hand_right and adjusting_rotation):
		var rotation_speed
		if is_on_floor(): rotation_speed = ground_rotation_speed
		else: rotation_speed = air_rotation_speed
		
		model.rotation.y = lerp_angle(model.rotation.y, adjusted_look_rotation, delta * rotation_speed * clampf(velocity.length(), 1, 2) * clampf(rotation_delta, 0.5, 1))
	
	
	# Apply movement
	var input_dir = input.movement.rotated(Vector3.UP, look.rotation.y)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
