extends Node

@export var head : Node3D
@export var holding_space_right : Node3D
@export var raycast : RayCast3D
@export var input : PlayerInput

@export_category("Cool Ape Stats")
@export var throw_power : float = 5.0

@export_category("Network shit (don't set)")
@export var grabbed_right : RigidBody3D

func _physics_process(delta: float) -> void:
	if grabbed_right:
		grabbed_right.global_position = holding_space_right.global_position
		grabbed_right.global_rotation = holding_space_right.global_rotation
		if not input.hand_right:
			grabbed_right.process_mode = Node.PROCESS_MODE_INHERIT
			grabbed_right.linear_velocity += -raycast.global_basis.z * 10
			grabbed_right = null
			
	elif input.hand_right and raycast.is_colliding():
		print("i'm grabbing ", raycast.get_collider())
		if raycast.get_collider() is RigidBody3D:
			grabbed_right = raycast.get_collider()
			grabbed_right.process_mode = Node.PROCESS_MODE_DISABLED
