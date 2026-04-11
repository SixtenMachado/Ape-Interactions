extends Node

@export_category("Cool Ape Stats")
@export var throw_power : float = 10.0
@export var grip_time : float = 10.0

@export_category("Animation")
@export var ik_speed : float = 15

@export_category("Node Buddies")
@export var head : Node3D
@export var holding_space_right : Node3D
@export var ik_right : JacobianIK3D
@export var hang_joint_right : PinJoint3D
@export var hand_bone_right : PhysicalBone3D
@export var raycast : RayCast3D
@export var input : PlayerInput
@export var ape : ApeBody
@export var look_pivot : Node3D
@export var state : PlayerState
@export var hitbox : RigidBodyHitbox
@export var authority_manager : AuthorityManager

@export_category("Network shit (don't set)")
@export var held_item_right : NetworkRigidBody

func lerp_ik_influence(delta: float, positive: bool = true, clamp_low : float = 0, clamp_high: float = 1):
	ik_right.influence = clampf(ik_right.influence + (delta * (ik_speed * ((float(positive) * 2) - 1))), clamp_low, clamp_high)
	
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():return
	if held_item_right:
		set_held_item_location(held_item_right, holding_space_right.global_transform)
		
		#interpolate the ik out a bit while holding something
		lerp_ik_influence(delta, false, 0.3, 1)
		
		if not input.hand_right:
			hitbox.ignore_thrown_rigid_body(held_item_right)
			held_item_right.process_mode = Node.PROCESS_MODE_INHERIT
			throw.call_deferred()
			authority_manager.release_authority.rpc_id(1, str(held_item_right.get_path()))
	
	elif hang_joint_right.node_a:
		lerp_ik_influence(delta, false)
		if not input.hand_right:
			hang_joint_right.node_b = ""
			hang_joint_right.node_a = ""
			state.current_state = state.State.NORMAL
	
	
	elif input.hand_right:
		lerp_ik_influence(delta)
		if raycast.get_collider() is NetworkRigidBody:
			held_item_right = raycast.get_collider()
			authority_manager.claim_authority.rpc_id(1, str(held_item_right.get_path()))
			held_item_right.process_mode = Node.PROCESS_MODE_DISABLED
		
		elif raycast.get_collider() is Node3D:
			var grabbed_node_right : Node3D
			grabbed_node_right= raycast.get_collider()
			hang_joint_right.global_position = raycast.get_collision_point()
			hand_bone_right.global_position = raycast.get_collision_point()
			hang_joint_right.node_a = grabbed_node_right.get_path()
			hang_joint_right.node_b = hand_bone_right.get_path()
			state.ragdoll(grip_time)
	
	else:
		lerp_ik_influence(delta, false)
	
	ik_right.active = bool(ik_right.influence != 0)

func throw():
	held_item_right.apply_impulse_rpc.rpc_id(1, (-look_pivot.global_basis.z + (Vector3.UP * 0.7)).normalized() * 10 + ape.velocity)
	held_item_right = null

func set_held_item_location(item:NetworkRigidBody, grab_transform:Transform3D):
	item.attach_to_grabber.rpc(grab_transform)
