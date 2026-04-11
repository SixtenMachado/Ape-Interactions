extends PhysicalBone3D

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if state.linear_velocity:
		state.linear_velocity = state.linear_velocity.limit_length(10)
