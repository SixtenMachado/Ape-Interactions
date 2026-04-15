extends PhysicalBoneSimulator3D
class_name Ragdoll

@export_category("Cool Ape Stats")
@export var swing_power : float = 2.0
@export var get_up_speed : float = 1.0

@export_category("Node Friends")
@export var input : PlayerInput
@export var state : PlayerState
@export var ape : ApeBody
@export var skeleton : Skeleton3D
@export var look_pivot : LookPivot

var ragdolling : bool = false
var getting_up : bool = false
var bones : Array[PhysicalBone3D]

func _ready() -> void:
	for bone in get_children().filter(func(x): return x is PhysicalBone3D):
		if bone is PhysicalBone3D:
			bones.append(bone)

func _physics_process(delta: float) -> void:
	#if !is_multiplayer_authority():return
		
	if input.ragdoll: 
		state.ragdoll()
		
	if state.current_state == state.State.RAGDOLL:
		getting_up = false
		influence = 1
		if not ragdolling:
			physical_bones_stop_simulation()
			physical_bones_start_simulation()
			ape.set_collision_layer_value(2, false)
			ragdolling = true
	else:
		if ragdolling and is_multiplayer_authority():
				ape.velocity = get_ragdoll_velocity()
				ape.global_position = $"Physical Bone Pelvis".global_position
		if influence == 0:
			physical_bones_stop_simulation()
			
			#for bone : PhysicalBone3D in bones:
					#bone.set_collision_mask_value(1, true)
		else:
			#if !getting_up:
				#for bone : PhysicalBone3D in bones:
					#bone.linear_velocity = Vector3.ZERO
					#bone.angular_velocity = Vector3.ZERO
					#bone.set_collision_mask_value(1, false)
			influence = clampf(influence - (delta * get_up_speed), 0, 1)
			ape.set_collision_layer_value(2, true)
			getting_up = true
			ragdolling = false

func get_ragdoll_velocity() -> Vector3:
	var swooce : Vector3
	swooce = bones.get(0).linear_velocity
	swooce *= (swing_power/1.5)
	
	swooce.y = clampf(swooce.y * (swing_power * 0.6), swing_power, 10) 
	print("swooce: ", swooce)
	return swooce
