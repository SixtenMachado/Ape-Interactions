extends Node

@export var threshold : float = 0.007
@export var frequency : float = 0.2

@export var voice : AudioStreamPlayer3D

var voice_playing : bool = false

func _ready() -> void:
	if is_multiplayer_authority(): 
		AudioServer.set_input_device_active(true)
		voice.volume_db = -30.0
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	
	
	if AudioServer.get_bus_effect_instance(3, 1) is AudioEffectSpectrumAnalyzerInstance:
#		Normal speaking pitch is 85-255 hz
		var spectrum : AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(3, 1)
		
		var pitches : Array[float]
		pitches.append(spectrum.get_magnitude_for_frequency_range(85, 100).x)
		pitches.append(spectrum.get_magnitude_for_frequency_range(101, 130).x)
		pitches.append(spectrum.get_magnitude_for_frequency_range(131, 160).x)
		pitches.append(spectrum.get_magnitude_for_frequency_range(161, 200).x)
		pitches.append(spectrum.get_magnitude_for_frequency_range(201, 250).x)
		pitches.append(spectrum.get_magnitude_for_frequency_range(251, 325).x)
		pitches.append(spectrum.get_magnitude_for_frequency_range(326, 450).x)
		pitches.append(spectrum.get_magnitude_for_frequency_range(451, 650).x)
		
		var highest_mag := threshold
		var pitch : int = -1
		var i : int
		for mag in pitches:
			if mag > highest_mag:
				highest_mag = mag
				pitch = i
			i += 1
		
		
		
		if pitch != -1:
			print(pitch, "is my pitch, magnitude is ", highest_mag)
			voice.pitch_scale = clampf(pitch, 1, 10)/8
			if not voice_playing:
				voice.play()
				voice_playing = true
				print("oo oo aa aa")


func _on_voice_finished() -> void:
	voice_playing = false
	print("done screeching")
	pass # Replace with function body.
