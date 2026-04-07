extends Control

func play_sound(sound: AudioStream, bus : String = "Sound", volume_linear : float = 1.0, pitch : float = -1, start_position : float = 0):
	var audio_player : AudioStreamPlayer = AudioStreamPlayer.new();
	audio_player.stream = sound;
	if pitch != -1:
		audio_player.pitch_scale = pitch;
	else:
		audio_player.pitch_scale = randf_range(0.8, 1.2);
	audio_player.bus = bus;
	audio_player.volume_linear = volume_linear;
	add_child(audio_player);
	audio_player.play(start_position);
	await audio_player.finished;
	audio_player.queue_free();
