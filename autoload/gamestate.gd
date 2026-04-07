extends Node

var gameplay_enabled : bool = true;

var preferences : GamePreferences = GamePreferences.new();

var save_path = "user://"
var save_file_name = "SaveData.json"
var full_path = save_path + "/" + save_file_name

func _ready() -> void:
	await get_tree().process_frame;
	get_tree().root.move_child(get_tree().current_scene,0);
	var canvas_layer : CanvasLayer = CanvasLayer.new();
	add_child(canvas_layer);
	GameplayInterface.reparent(canvas_layer);
	PauseMenu.reparent(canvas_layer);
	ScreenTransition.reparent(canvas_layer);
	dummy_save_file_test();
	
func dummy_save_file_test() -> void:
	if not load_progress():
		save_progress();
	else:
		print(preferences.profile_name);
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),preferences.desired_music_volume);
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Sound"),preferences.desired_sound_volume);
	get_window().mode = preferences.desired_window_mode;

func save_progress() -> void:
	print("Saving Progression to %s", full_path);
	if not DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_absolute(save_path);
	var file = FileAccess.open(full_path, FileAccess.WRITE);
	var json_text = SimpleJsonClassConverter.class_to_json_string(preferences);
	file.store_string(json_text);

func load_progress() -> bool:
	print("Loading Progression at %s", full_path);
	if FileAccess.file_exists(full_path):
		var file = FileAccess.open(full_path, FileAccess.READ);
		var json_string = file.get_as_text();
		var json = JSON.new();
		var result = json.parse(json_string);
		if result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line());
			return false;
		preferences = SimpleJsonClassConverter.json_string_to_class(json_string);
		if preferences == null:
			return false;
		return true;
	else:
		print("No save file to load!");
		return false;

func enable_gameplay() -> void:
	gameplay_enabled = true;

func disable_gameplay() -> void:
	gameplay_enabled = false;

func slow_mo_effect() -> void:
	Engine.time_scale = 0.2;
	#GameplayInterface.play_sound(load("res://audio/sfx/slowmo/slowmo.tres"),"Sound",0.2);
	await get_tree().create_timer(0.34,false).timeout;
	Engine.time_scale = 1.0;

func go_to_scene(destination:String):
	ScreenTransition.show();
	ScreenTransition.play("cover_screen");
	await ScreenTransition.animation_finished;
	get_tree().change_scene_to_file(destination);
	await get_tree().scene_changed;
	get_tree().root.move_child(get_tree().current_scene,0);
	ScreenTransition.play_backwards("cover_screen");
	await ScreenTransition.animation_finished;
	ScreenTransition.hide();

func _exit_tree() -> void:
	Gamestate.save_progress();
