extends PhysicalBoneSimulator3D
class_name Ragdoll

@export var input : PlayerInput
@export var state : PlayerState
@export var ape : ApeBody
@export var skeleton : Skeleton3D
@export var get_up_speed : float = 1.0

var ragdolling : bool = false


#func _ready() -> void:
	#await get_tree().process_frame
	#physical_bones_start_simulation()

func _physics_process(delta: float) -> void:
	if input.ragdoll or state.current_state == state.State.RAGDOLL:
		if not ragdolling:
			physical_bones_stop_simulation()
			physical_bones_start_simulation()
			influence = 1
			ape.set_collision_layer_value(1, false)
			ragdolling = true
	else:
		if influence == 0:
			physical_bones_stop_simulation()
		else:
			influence = clampf(influence - (delta * get_up_speed), 0, 1)
		ape.set_collision_layer_value(1, true)
		ragdolling = false
