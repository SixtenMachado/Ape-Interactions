extends Node3D

@export var input: PlayerInput

func _physics_process(delta: float) -> void:
	#DO BASIS SHIT
	#Handle look left and right
	#rotate(Vector3(0, 1, 0), input.look_angle.x)
	rotation.y += (input.look_angle.x)
	rotation.x += (input.look_angle.y)
	#
	## Handle look up and down
	#rotate(Vector3(1, 0, 0), input.look_angle.y)

	rotation.x = clamp(rotation.x, -0.57, 1.57)
	rotation.z = 0
#	TODO: put looking code here, then make player rotate to face camera when moving
	
	#position = get_parent().global_position
