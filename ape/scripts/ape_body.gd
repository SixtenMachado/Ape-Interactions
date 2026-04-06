extends CharacterBody3D
class_name ApeBody

@export var speed := 4.0
@export var jump_strength := 5.0
@export var input: PlayerInput
@export var camera: Camera3D
@export var look: Node3D
@export var model: Node3D
@export var state: PlayerState

@export var bone_data : Array[Vector3]
@export var bone_transforms : Array[Transform3D]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting(&"physics/3d/default_gravity")

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
	
	## TODO: move this out to LookPivot, greater separation between camera and body
	## Handle look left and right
	#rotate_object_local(Vector3(0, 1, 0), input.look_angle.x)
#
	## Handle look up and down
	#look.rotate_object_local(Vector3(1, 0, 0), input.look_angle.y)
#
	#look.rotation.x = clamp(look.rotation.x, -0.57, 1.57)
	#look.rotation.z = 0
	#look.rotation.y = 0
	var adjusted_look_rotation := Vector3(0, look.rotation.y, 0) + Vector3(0, deg_to_rad(180), 0)
	model.rotation = model.rotation.lerp(adjusted_look_rotation, delta * velocity.length())
	
	
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
