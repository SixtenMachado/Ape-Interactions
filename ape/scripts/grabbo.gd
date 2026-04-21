extends Node

@export var right_hand : bool = true

@export_category("Cool Ape Stats")
@export var throw_power : float = 10.0
@export var grip_time : float = 60.0

@export_category("Animation")
@export var ik_speed : float = 15

@export_category("Node Buddies")
@export var head : Node3D
@export var holding_space : Node3D
@export var ik : JacobianIK3D
@export var hang_joint : PinJoint3D
@export var hand_bone : PhysicalBone3D
@export var raycast : RayCast3D
@export var input : PlayerInput
@export var ape : ApeBody
@export var look_pivot : Node3D
@export var state : PlayerState
@export var hitbox : RigidBodyHitbox
@export var authority_manager : AuthorityManager

@export_category("Network shit (don't set)")
@export var held_item : NetworkRigidBody


var pressed : bool
var cooldown : bool = false
var timer : SceneTreeTimer

func lerp_ik_influence(delta: float, positive: bool = true, clamp_low : float = 0, clamp_high: float = 1):
	ik.influence = clampf(ik.influence + (delta * (ik_speed * ((float(positive) * 2) - 1))), clamp_low, clamp_high)
	
func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():return
	
	if right_hand:
		pressed = input.hand_right
	else:
		pressed = input.hand_left
	
	if held_item:
		set_held_item_location(held_item, holding_space.global_transform)
		
		#interpolate the ik out a bit while holding something
		lerp_ik_influence(delta, false, 0.3, 1)
		
		if not pressed:
			hitbox.ignore_thrown_rigid_body(held_item)
			held_item.process_mode = Node.PROCESS_MODE_INHERIT
			throw.call_deferred()
			authority_manager.release_authority.rpc_id(1, str(held_item.get_path()))
			start_cooldown()
	
	elif hang_joint.node_a:
		lerp_ik_influence(delta, false)
		if not pressed:
			hang_joint.node_b = ""
			hang_joint.node_a = ""
			
			if right_hand:
				state.right_hand_grab = false
			else:
				state.left_hand_grab = false
			
			if not (state.right_hand_grab or state.left_hand_grab):
				state.current_state = state.State.NORMAL
			
			start_cooldown()
	
	#Grab item
	elif pressed and not cooldown:
		lerp_ik_influence(delta)
		if raycast.get_collider() is NetworkRigidBody:
			held_item = raycast.get_collider()
			authority_manager.claim_authority.rpc_id(1, str(held_item.get_path()))
			held_item.process_mode = Node.PROCESS_MODE_DISABLED
		
		#Grab and swing
		elif raycast.get_collider() is Node3D:
			var grabbed_node : Node3D
			grabbed_node = raycast.get_collider()
			hang_joint.global_position = raycast.get_collision_point()
			hand_bone.global_position = raycast.get_collision_point()
			hang_joint.node_a = grabbed_node.get_path()
			hang_joint.node_b = hand_bone.get_path()
			state.ragdoll(grip_time + (999 * float(!state.hungry)))
			if right_hand:
				state.right_hand_grab = true
			else:
				state.left_hand_grab = true
	
	else:
		lerp_ik_influence(delta, false)
	
	ik.active = bool(ik.influence != 0)

func throw():
	var mod_throw_power = throw_power
	if state.hungry:
		mod_throw_power = mod_throw_power / 2
	held_item.apply_impulse_rpc.rpc_id(1, (-look_pivot.global_basis.z + (Vector3.UP * 0.7)).normalized() * mod_throw_power + ape.velocity)
	held_item = null

func set_held_item_location(item:NetworkRigidBody, grab_transform:Transform3D):
	item.attach_to_grabber.rpc(grab_transform)

func start_cooldown():
	if cooldown: return
	cooldown = true
	await get_tree().create_timer(0.33).timeout
	end_cooldown()

func end_cooldown():
	cooldown = false
	print("balatro")
