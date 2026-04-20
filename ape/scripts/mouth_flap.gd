extends BoneAttachment3D

@export var voice : ApeVoice

var smoothed_volume : float

func _process(delta: float) -> void:
	var volume = voice.analyzer.get_magnitude_for_frequency_range(80, 600).x
	smoothed_volume = lerpf(smoothed_volume, volume, delta * 25)
	get_skeleton().set_bone_pose(bone_idx, get_skeleton().get_bone_rest(bone_idx).rotated(Vector3.RIGHT, 0.35 * clampf(smoothed_volume * 50, 0, 1)))
