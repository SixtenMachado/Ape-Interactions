extends PhysicalBoneSimulator3D
class_name Ragdoll

@export var input : PlayerInput
@export var state : PlayerState
@export var ape : ApeBody


func _physics_process(delta: float) -> void:
	if input.ragdoll or state.current_state == state.State.RAGDOLL:
		physical_bones_start_simulation()
		ape.set_collision_layer_value(1, false)
		if !is_multiplayer_authority():
			network_update_bones(delta)
		else:
			ape.bone_data.clear()
			for child in get_children():
				if child is PhysicalBone3D:
					var bone : PhysicalBone3D = child
					ape.bone_data.append(bone.angular_velocity)
					ape.bone_data.append(bone.linear_velocity)
					ape.bone_transforms.append(bone.transform)
	else:
		physical_bones_stop_simulation()
		ape.set_collision_layer_value(1, true)

#TODO: figure out the smartest ape way to sync all the bones
func network_update_bones(delta: float):
	if is_multiplayer_authority(): return
	var index : int = 0
	if !ape.bone_transforms.is_empty():
		for bone : PhysicalBone3D in get_children():
			bone.angular_velocity = lerp(bone.angular_velocity, ape.bone_data.get(index), delta * 10)
			index += 1
			bone.linear_velocity = lerp(bone.linear_velocity, ape.bone_data.get(index), delta * 10)
			index += 1
	
	var transform_index : int = 0
	if !ape.bone_transforms.is_empty():
		for bone : PhysicalBone3D in get_children():
			bone.transform = lerp(bone.transform, ape.bone_transforms.get(transform_index), delta * 10)
			transform_index += 1
