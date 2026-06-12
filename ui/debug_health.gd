extends Label3D

func _ready() -> void:
	DeveloperConsole.debug.connect(toggle)
	hide()
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	no_depth_test = true

func toggle(show : bool):
	print("hide me!")
	if show:
		show()
	else:
		hide()
