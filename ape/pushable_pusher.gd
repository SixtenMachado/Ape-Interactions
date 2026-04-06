extends Area3D

@export var armor : float = 2.0
@export var state : PlayerState

@export var power : float = 2.0
@export var ape : ApeBody

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var pushable : RigidBody3D = body
		
		if pushable.linear_velocity.length() > armor:
			state.current_state =  state.State.RAGDOLL
		
		#TODO: replace get_parent_node with something smarter maybe
		pushable.apply_impulse(((global_position.direction_to(pushable.global_position) * Vector3(1, 0, 1)) + Vector3(0, 0.5, 0)) * (get_parent_node_3d().linear_velocity.length() + 1) * power, global_position)
		#pushable.linear_velocity += (global_position.direction_to(pushable.global_position) * Vector3(1, 0, 1)) + Vector3(0, 0.5, 0) * ape.velocity.length() * power
