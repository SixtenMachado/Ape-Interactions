extends RayCast3D

@export var extra_reach : float = 0
@export var target_child : Node3D
@export var ignore_these : Array[CollisionObject3D]

func _ready() -> void:
	for this in ignore_these:
		add_exception(this)

func _physics_process(delta: float) -> void:
	global_rotation = Vector3.ZERO
	target_position = target_child.global_position - global_position
	target_position += position.direction_to(target_position) * extra_reach
