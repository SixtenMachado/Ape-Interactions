extends AudioStreamPlayer3D
class_name ApeVoice

@rpc("any_peer", "call_local")
func utter(pscale : float):
	print("im an utterance baby, pitch scale ", pscale)
	$VoiceInput.voice_playing = true
	pitch_scale = pscale
	play()
	if is_multiplayer_authority():
		$AnimatedSprite3D.stop()
		$AnimatedSprite3D.flip_h = !$AnimatedSprite3D.flip_h 
		$AnimatedSprite3D.play("default")

func _on_finished() -> void:
	$VoiceInput.voice_playing = false
	pass # Replace with function body.
