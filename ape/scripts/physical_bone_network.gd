extends PhysicalBone3D

var parent : Ragdoll

func _ready() -> void:
#	Parent needs to be ragdoll, but i think that's inevitable
	parent = get_parent()
	

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	return
	if !is_multiplayer_authority():
		var id := get_bone_id()
		if parent.bone_transforms.get(id):
			global_transform = parent.bone_transforms.get(id)
			angular_velocity = parent.bone_angular_velocities.get(id)
			linear_velocity = parent.bone_linear_velocities.get(id)
		else:
			print("i don't have any bone data!1")
