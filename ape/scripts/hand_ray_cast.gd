extends RayCast3D

@export var target_child : Node3D

func _ready() -> void:
	target_position = target_child.position
