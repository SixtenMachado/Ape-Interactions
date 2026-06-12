extends LineEdit

var active := false
var show_debug := false
signal debug(show:bool)

func _ready() -> void:
	release_focus()
	_on_focus_exited()
	text_submitted.connect(_on_text_submitted)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_console"):
		if active:
			release_focus()
			_on_focus_exited()
		else:
			show()
			grab_focus()
			text = ""

func _on_focus_exited() -> void:
	active = false
	hide()
	text = ""

func enter_command():
	print(text)
	match text:
		"banana":
			var banana_scene : PackedScene = load("res://props/banana.tscn")
			var banana = banana_scene.instantiate()
			add_child(banana)
			banana.global_position = Gamestate.player.look.global_position + (Gamestate.player.look.global_basis.z * -1)
#			TODO: make the banana networky
			print("spawn a banana")
		
		"funnyjump 1":
			Gamestate.player.input.enable_funny_jump = true
			print("enable funny jumping")
		
		"funnyjump 0":
			Gamestate.player.input.enable_funny_jump = false
			print("disable funny jumping")
		
		"respawn":
			print("respawn as new ape")
		
		"debug 1":
			show_debug = true
			debug.emit(show_debug)
			print("show debug stuff")
			
		"debug 0":
			show_debug = false
			debug.emit(show_debug)
			print("hide")


func _on_text_submitted(new_text: String) -> void:
	print(new_text)
	enter_command()
	release_focus()
	_on_focus_exited()
