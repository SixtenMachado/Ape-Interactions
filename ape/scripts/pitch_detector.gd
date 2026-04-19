extends Node
class_name VoiceInput

@export var threshold : float = 0.01
@export var frequency : float = 0.2

@export var voice : ApeVoice

var voice_playing : bool = false

func _ready() -> void:
	if is_multiplayer_authority(): 
		AudioServer.set_input_device_active(true)
		voice.volume_db = -10.0
		voice.attenuation_filter_cutoff_hz = 5000
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	#Normal speaking pitch is 85-255 hz
	var spectrum : AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(3, 1)
	
	var pitches : Array[float]
	pitches.append(spectrum.get_magnitude_for_frequency_range(90, 130).x)
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
		if not voice_playing:
			var pscale = clampf(pitch + 4.5, 0, 99)/9
			voice.utter.rpc(pscale)
			print("pscale: ", pscale, "     ", pitch, "is my pitch, magnitude is ", highest_mag)
