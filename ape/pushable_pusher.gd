extends Area3D

@export var power : float = 2.0
@export var ape : ApeBody

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var pushable : RigidBody3D = body
		pushable.apply_impulse(((global_position.direction_to(pushable.global_position) * Vector3(1, 0, 1)) + Vector3(0, 0.5, 0)) * ape.velocity.length() * power, global_position)
		#pushable.linear_velocity += (global_position.direction_to(pushable.global_position) * Vector3(1, 0, 1)) + Vector3(0, 0.5, 0) * ape.velocity.length() * power
