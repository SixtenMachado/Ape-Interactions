extends BoneAttachment3D

@export var voice : ApeVoice
@export var mesh : MeshInstance3D

var smoothed_volume : float = 0

func _process(delta: float) -> void:
	if voice.playing:
		var volume = voice.analyzer.get_magnitude_for_frequency_range(100, 500).x
		if volume > smoothed_volume: 
			smoothed_volume = volume
		else:
			smoothed_volume = lerpf(smoothed_volume, volume, delta * 2)
	else:
		smoothed_volume = lerpf(smoothed_volume, 0, delta * 40)
	
	get_skeleton().set_bone_pose(bone_idx, get_skeleton().get_bone_rest(bone_idx).rotated(Vector3.RIGHT, 0.4 * clampf(smoothed_volume * 50, 0, 1)))
	mesh.set_blend_shape_value(0, voice.volume_linear * 2 * float(voice.playing))
