extends Area3D
class_name RigidBodyHitbox

@export var armor : float = 2.0

@export var power : float = 2.0
@export var ape : ApeBody
@export var state : PlayerState
@export var ragdoll : Ragdoll

var ignored_body : RigidBody3D

func _on_body_entered(body: Node3D) -> void:
	if body == ignored_body: 
		return
	if body is RigidBody3D:
		var pushable : RigidBody3D = body
		
		if pushable.linear_velocity.length() > armor:
			state.ragdoll()
			ragdoll_impulse.call_deferred(body)
		
		var added_velocity : float = ape.velocity.length()
		if state.current_state == state.State.RAGDOLL: added_velocity = get_parent_node_3d().linear_velocity.length()
		
		#TODO: replace get_parent_node with something smarter maybe
		pushable.apply_central_impulse(((global_position.direction_to(pushable.global_position) * Vector3(1, 0, 1)) + Vector3(0, 0.5, 0)) * (added_velocity + 1) * power)

func ignore_thrown_rigid_body(body: RigidBody3D, time: float = 0.4):
	ignored_body = body
	await get_tree().create_timer(time).timeout
	ignored_body = null

func ragdoll_impulse(body:RigidBody3D):
	for bone in ragdoll.bones:
		bone.apply_impulse(body.linear_velocity, body.global_position)
