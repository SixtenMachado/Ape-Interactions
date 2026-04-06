extends PhysicalBoneSimulator3D
class_name Ragdoll

@export var input : PlayerInput
@export var state : PlayerState
@export var ape : ApeBody
@export var skeleton : Skeleton3D

var ragdolling : bool = false

func _ready() -> void:
	await get_tree().process_frame
	physical_bones_start_simulation()

func _physics_process(delta: float) -> void:
	if input.ragdoll or state.current_state == state.State.RAGDOLL:
		if not ragdolling:
			for bone : PhysicalBone3D in get_children().filter(func(x): return x is PhysicalBone3D):
				bone.transform = skeleton.get_bone_pose(bone.get_bone_id())
		physical_bones_start_simulation()
		#influence = lerpf(influence, 1, delta * 3)
		ape.set_collision_layer_value(1, false)
		ragdolling = true
	else:
		physical_bones_stop_simulation()
		#influence = lerpf(influence, 0, delta * 3)
		ape.set_collision_layer_value(1, true)
		ragdolling = false
