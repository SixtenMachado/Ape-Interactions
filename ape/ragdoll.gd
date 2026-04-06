extends PhysicalBoneSimulator3D

@export var input : PlayerInput
@export var state : PlayerState
@export var ape : ApeBody

func _physics_process(delta: float) -> void:
	if input.ragdoll or state.current_state == state.State.RAGDOLL:
		physical_bones_start_simulation()
		ape.set_collision_layer_value(1, false)
	else:
		physical_bones_stop_simulation()
		ape.set_collision_layer_value(1, true)
