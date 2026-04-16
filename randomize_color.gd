extends MeshInstance3D

@onready var material : ShaderMaterial = mesh.surface_get_material(0)

@export_category("Min and Max Variance")
@export var red_hue : Vector2 = Vector2(-0.01, 0.01)
@export var red_sat : Vector2 = Vector2(-0.01, 0.01)
@export var red_val : Vector2  = Vector2(-0.2, 0.2)

@export var black_hue : Vector2 = Vector2(-0.05, 0.05)
@export var black_sat : Vector2 = Vector2(-0.05, 0.05)
@export var black_val : Vector2 = Vector2(-0.05, 0.15)

@export_category("network shit")
@export var red_color : Color = Color.GREEN
@export var black_color : Color = Color.GREEN

func _ready() -> void:
	#if !is_multiplayer_authority(): return
	red_color = get_instance_shader_parameter("red_color")
	red_color = _generate_random_hsv_color(red_color, red_hue, red_sat, red_val)
	set_instance_shader_parameter("red_color", red_color)
	
	black_color = get_instance_shader_parameter("black_color")
	black_color = _generate_random_hsv_color(black_color, black_hue, black_sat, black_val)
	set_instance_shader_parameter("black_color", black_color)


func _generate_random_hsv_color(color : Color, hue : Vector2, sat : Vector2, val : Vector2) -> Color:
	return Color.from_hsv(
		randf_range(color.h + hue.x, color.h + hue.y), # HUE
		randf_range(color.s + sat.x, color.s + sat.y), # SATURATION
		randf_range(color.v + val.x, color.v + val.y), # VALUE (or brightness)
	)
