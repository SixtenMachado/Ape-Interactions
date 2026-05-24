extends ColorRect
class_name Vignette

func _ready() -> void:
	Gamestate.vignette = self

func display(show : bool):
	(material as ShaderMaterial).set_shader_parameter("alpha", 0.33 * float(show))
