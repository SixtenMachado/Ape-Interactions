extends Node

@export var head : Node3D
@export var holding_space_right : Node3D
@export var ik_right : JacobianIK3D
@export var raycast : RayCast3D
@export var input : PlayerInput
@export var ape : ApeBody
@export var hitbox : RigidBodyHitbox

@export_category("Cool Ape Stats")
@export var throw_power : float = 10.0

@export_category("Animation")
@export var ik_speed : float = 15

@export_category("Network shit (don't set)")
@export var held_item_right : RigidBody3D

func lerp_ik_influence(delta: float, positive: bool = true, clamp_low : float = 0, clamp_high: float = 1):
	ik_right.influence = clampf(ik_right.influence + (delta * (ik_speed * ((float(positive) * 2) - 1))), 0.3, 1)
	
func _physics_process(delta: float) -> void:
	if held_item_right:
		set_held_item_location(held_item_right, holding_space_right.global_transform)
		
		#interpolate the ik out a bit while holding something
		lerp_ik_influence(delta, false, 0.3, 1)
		
		if not input.hand_right:
			hitbox.ignore_thrown_rigid_body(held_item_right)
			held_item_right.process_mode = Node.PROCESS_MODE_INHERIT
			throw()
			held_item_right = null
	
	elif input.hand_right:
		lerp_ik_influence(delta)
		if raycast.get_collider() is RigidBody3D:
			held_item_right = raycast.get_collider()
			held_item_right.process_mode = Node.PROCESS_MODE_DISABLED
	
	else:
		lerp_ik_influence(delta, false)
	
	ik_right.active = bool(ik_right.influence != 0)

func throw():
	held_item_right.apply_central_impulse((-raycast.global_basis.z + (Vector3.UP * 0.7)).normalized() * 10 + ape.velocity)


func set_held_item_location(item:RigidBody3D, transform:Transform3D):
	item.global_position = transform.origin
	item.global_basis = transform.basis
