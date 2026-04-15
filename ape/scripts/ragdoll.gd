extends PhysicalBoneSimulator3D
class_name Ragdoll

@export_category("Cool Ape Stats")
@export var swing_power : float = 2.0
@export var get_up_speed : float = 1.0
@export var directional_influence_speed : float = 15

@export_category("Node Friends")
@export var input : PlayerInput
@export var state : PlayerState
@export var ape : ApeBody
@export var skeleton : Skeleton3D
@export var look_pivot : LookPivot
@export var pelvis : PhysicalBone3D

var ragdolling : bool = false
var getting_up : bool = false
var bones : Array[PhysicalBone3D]
var funny_jump_blocker : float
var funny_jump_enabled : bool = false

func _ready() -> void:
	for bone in get_children().filter(func(x): return x is PhysicalBone3D):
		if bone is PhysicalBone3D:
			bones.append(bone)

func _physics_process(delta: float) -> void:
	#if !is_multiplayer_authority():return
#	If funny jump isn't enabled, use this to block that shit
	if not input.enable_funny_jump:
		if ape.is_on_floor():
				funny_jump_blocker = 0.2
		else:
			# Tick up the funny jump blocker, which modifies max Y velocity coming out of ragdoll
			funny_jump_blocker = clampf(funny_jump_blocker + (delta * 2), 0.2, 1)
	else: funny_jump_blocker = 1
	
	if input.ragdoll: 
		state.ragdoll()
		
	if state.current_state == state.State.RAGDOLL:
		getting_up = false
		influence = 1
		
		# apply directional influence
		directional_influence(delta)
		
		if not ragdolling:
			physical_bones_stop_simulation()
			physical_bones_start_simulation()
			ape.set_collision_layer_value(2, false)
			ragdolling = true
	else:
		if ragdolling and is_multiplayer_authority():
				ape.velocity = get_ragdoll_velocity()
				ape.global_position = pelvis.global_position
		if influence == 0:
			physical_bones_stop_simulation()
		else:
			influence = clampf(influence - (delta * get_up_speed), 0, 1)
			ape.set_collision_layer_value(2, true)
			getting_up = true
			ragdolling = false

func get_ragdoll_velocity() -> Vector3:
	var swooce : Vector3
	swooce = bones.get(0).linear_velocity
	swooce *= clampf(swing_power/1.5 * funny_jump_blocker, 1.1, 99)
	swooce.y = clampf(swooce.y * (swing_power * 0.6 * funny_jump_blocker), swing_power, 1 + (10 * funny_jump_blocker)) 
	print("swooce: ", swooce)
	return swooce

func directional_influence(delta : float):
	var input_dir = input.movement.rotated(Vector3.UP, ape.look.rotation.y)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()
	if direction:
		pelvis.apply_central_impulse(
			delta 
			* Vector3(direction.x, -1, direction.z) 
			* directional_influence_speed
			)
