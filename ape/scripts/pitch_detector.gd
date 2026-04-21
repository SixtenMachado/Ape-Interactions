extends Node
class_name VoiceInput

@export var threshold : float = 0.01
@export var frequency : float = 0.2

@export var voice : ApeVoice

var voice_playing : bool = false
var loud_smoothed : float = 0

func _ready() -> void:
	if is_multiplayer_authority(): 
		AudioServer.set_input_device_active(true)
		voice.volume_db = -10.0
		voice.attenuation_filter_cutoff_hz = 5000
	
func _physics_process(delta: float) -> void:
	if !voice.input.mic: return
	#Normal speaking pitch is 85-255 hz
	var spectrum : AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(3, 1)
	
	var pitches : Array[float]
	pitches.append(spectrum.get_magnitude_for_frequency_range(90, 115).x - 0.003)
	pitches.append(spectrum.get_magnitude_for_frequency_range(116, 160).x - 0.001)
	pitches.append(spectrum.get_magnitude_for_frequency_range(161, 200).x)
	pitches.append(spectrum.get_magnitude_for_frequency_range(201, 250).x - 0.001)
	pitches.append(spectrum.get_magnitude_for_frequency_range(251, 325).x - 0.002)
	pitches.append(spectrum.get_magnitude_for_frequency_range(326, 450).x - 0.004)
	pitches.append(spectrum.get_magnitude_for_frequency_range(451, 650).x - 0.008)
	pitches.append(spectrum.get_magnitude_for_frequency_range(651, 750).x - 0.01)
	
	var loud : float = 0.05
	var highest_mag := threshold
	var pitch : int = -1
	var i : int = 0
	for mag in pitches:
		loud += mag
		if mag > highest_mag:
			highest_mag = mag
			pitch = i
		i += 1
	
	if loud > loud_smoothed: loud_smoothed = loud
	else: loud_smoothed = move_toward(loud_smoothed, loud, delta * 0.75)
	
	if pitch != -1 and not voice.playing:
		var pscale = clampf(pitch + 1, 0, 99)/4.5
		voice.utter.rpc(pscale, loud_smoothed)
		
		print("pscale: ", pscale, "     ", pitch, "is my pitch, magnitude is ", highest_mag)
