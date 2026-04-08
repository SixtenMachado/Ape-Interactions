extends Node

@export var head : Node3D
@export var holding_space_right : Node3D
@export var ik_right : JacobianIK3D
@export var raycast : RayCast3D
@export var input : PlayerInput
@export var hitbox : RigidBodyHitbox

@export_category("Cool Ape Stats")
@export var throw_power : float = 10.0

@export_category("Animation")
@export var ik_speed : float = 15

@export_category("Network shit (don't set)")
@export var held_item_right : RigidBody3D

func _physics_process(delta: float) -> void:
	ik_right.active = input.hand_right
	
	if held_item_right:
		held_item_right.global_position = holding_space_right.global_position
		held_item_right.global_rotation = holding_space_right.global_rotation
		
		ik_right.influence = clampf(ik_right.influence - (delta * ik_speed), 0.3, 1)
		ik_right.active = bool(ik_right.influence != 0)
		
		if not input.hand_right:
			hitbox.ignore_thrown_rigid_body(held_item_right)
			held_item_right.process_mode = Node.PROCESS_MODE_INHERIT
			throw()
			held_item_right = null
	
	elif input.hand_right:
		ik_right.influence = 1
		if raycast.get_collider() is RigidBody3D:
			held_item_right = raycast.get_collider()
			held_item_right.process_mode = Node.PROCESS_MODE_DISABLED

func throw():
	held_item_right.linear_velocity += (-raycast.global_basis.z + (Vector3.UP * 0.7)).normalized() * 10
