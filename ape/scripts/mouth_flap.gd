extends BoneAttachment3D

@export var voice : ApeVoice

var smoothed_volume : float

func _process(delta: float) -> void:
	var volume = voice.analyzer.get_magnitude_for_frequency_range(80, 600).x
	
	smoothed_volume = move_toward(smoothed_volume, volume, delta * 3)
	if smoothed_volume == 0: return
	get_skeleton().set_bone_pose_rotation(bone_idx, get_skeleton().get_bone_rest(bone_idx).basis)
	print ("utter this: ", smoothed_volume)

#	TODO: figure out how to actually do this

	#get_skeleton().set_bone_global_pose_rotation(
		#bone_idx, 
		#get_skeleton().get_bone_global_pose_rotation(bone_idx) 
		#* (1 + (voice.analyzer.get_magnitude_for_frequency_range(80, 300).x * 10))
		#)
	#get_skeleton().set_bone_global_pose_override(
		#bone_idx, 
		#get_skeleton().get_bone_global_pose_no_override(bone_idx).looking_at(global_position - (Vector3.DOWN * 2)), 
		#0.5, 
		#true)
		#
		
	var bone_rotation: Quaternion = get_skeleton().get_bone_pose_rotation(bone_idx)
	var skeleton_global_rotation: Quaternion = get_skeleton().global_transform.basis.get_rotation_quaternion()

	var bone_global_rotation: Quaternion = skeleton_global_rotation * bone_rotation

	var new_bone_global_rotation: Quaternion = Quaternion(basis.z.rotated(Vector3.FORWARD, 0.2).rotated(Vector3.UP, 0.2), 0.4) * bone_global_rotation
	var new_bone_rotation: Quaternion = (bone_global_rotation.inverse() * new_bone_global_rotation).normalized()

	get_skeleton().set_bone_pose_rotation(bone_idx, get_skeleton().get_bone_rest(bone_idx).basis.slerp(new_bone_rotation, smoothed_volume * 50))
