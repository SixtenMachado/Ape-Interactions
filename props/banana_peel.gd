extends Area3D

func _on_area_entered(area: Area3D) -> void:
	print("i slip on da peel")
	if area is RigidBodyHitbox:
		var hit : RigidBodyHitbox = area
		hit.state.ragdoll()
		slip.call_deferred(area)

func slip(hit : RigidBodyHitbox):
	for bone in hit.ragdoll.bones:
			bone.apply_impulse((hit.global_position.direction_to(global_position) + hit.ape.velocity * Vector3(1,0,1)) + (Vector3.UP * 2) * 2.5, global_position)
	
	var parent : NetworkRigidBody = get_parent()
	parent.apply_torque_impulse(Vector3(randf(), randf(), randf()))
	
	disable_collision()

func disable_collision():
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.2).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
