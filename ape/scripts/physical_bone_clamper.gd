extends PhysicalBone3D

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	linear_velocity = linear_velocity.limit_length(10)
