extends Control
var last_focused : Control;
func _ready() -> void:
	hide();
	$MusicSlider.value_changed.connect(set_music_volume);
	$SoundSlider.value_changed.connect(set_sound_volume);
	$Resume.pressed.connect(resume);
	$Quit.pressed.connect(quit);
	$Windowed.pressed.connect(windowed_mode);
	$Fullscreen.pressed.connect(fullscreen_mode);
	$Fullscreen2.pressed.connect(exclusive_fullscreen_mode);
	$ReturnToTitle.pressed.connect(return_to_title);
	$MyGames.pressed.connect(go_to_my_games);
func go_to_my_games() -> void:
	OS.shell_open("https://sixten-machado.itch.io/");
func return_to_title() -> void:
	#Gamestate.go_to_scene("res://title_scene/title.tscn");
	toggle_pause();
func resume() -> void:
	toggle_pause();
func windowed_mode() -> void:
	get_window().mode = Window.MODE_WINDOWED;
	Gamestate.preferences.desired_window_mode = 0;
func fullscreen_mode() -> void:
	get_window().mode = Window.MODE_FULLSCREEN;	
	Gamestate.preferences.desired_window_mode = 3;
func exclusive_fullscreen_mode() -> void:
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN;	
	Gamestate.preferences.desired_window_mode = 4;
func quit() -> void:
	get_tree().quit();
func toggle_pause() -> void:
	visible = !visible;
	#get_tree().paused = visible; #use to pause stuff (check process_mode on any node), not really useful for online apes
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		last_focused = get_viewport().gui_get_focus_owner();
		$MusicSlider.value = Gamestate.preferences.desired_music_volume;
		$SoundSlider.value = Gamestate.preferences.desired_sound_volume;
		$MusicSlider.grab_focus();
	elif last_focused != null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		last_focused.grab_focus();
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause();
func set_music_volume(volume:float):
	Gamestate.preferences.desired_music_volume = volume;
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),volume);
func set_sound_volume(volume:float):
	Gamestate.preferences.desired_sound_volume = volume;
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Sound"),volume);
