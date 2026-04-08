extends Node3D
class_name LookPivot

@export var input: PlayerInput
@export var ragdoll : Ragdoll
@export var attach_bone: Node3D

var camera_smoothing : bool = false

func _physics_process(delta: float) -> void:
	if ragdoll.getting_up:
		global_position = lerp(global_position, attach_bone.global_position, 1 - ragdoll.influence)
	else: global_position = attach_bone.global_position
	
	rotation.y += (input.look_angle.x)
	rotation.x += (input.look_angle.y)

	rotation.x = clamp(rotation.x, -0.75, 0.75)
	rotation.z = 0
