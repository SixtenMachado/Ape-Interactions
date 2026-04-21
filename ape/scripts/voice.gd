extends AudioStreamPlayer3D
class_name ApeVoice

var idx : int = -1
var analyzer : AudioEffectSpectrumAnalyzerInstance
@export var curve : Curve
@export var input : PlayerInput

func _ready() -> void:
	idx = AudioServer.bus_count
	AudioServer.add_bus(idx)
	AudioServer.set_bus_send(idx, "Sound")
	AudioServer.add_bus_effect(idx, AudioEffectSpectrumAnalyzer.new())
	var effect = AudioServer.get_bus_effect(idx, 0)
	effect.buffer_length = 1
	effect.fft_size = 3
	analyzer = AudioServer.get_bus_effect_instance(idx, 0)
	bus = AudioServer.get_bus_name(idx)

@rpc("any_peer", "call_local")
func utter(pscale : float, loud : float):
	print("im an utterance baby, pitch scale ", pscale)
	$VoiceInput.voice_playing = true
	pitch_scale = pscale
	volume_linear = curve.sample(loud)
	play()
	if is_multiplayer_authority():
		$AnimatedSprite3D.pixel_size = volume_linear * 0.005
		$AnimatedSprite3D.stop()
		$AnimatedSprite3D.flip_h = !$AnimatedSprite3D.flip_h 
		$AnimatedSprite3D.play("default")

func _on_finished() -> void:
	$VoiceInput.voice_playing = false
	pass # Replace with function body.
