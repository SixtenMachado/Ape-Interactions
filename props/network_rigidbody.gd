extends RigidBody3D
class_name NetworkRigidBody

@rpc("any_peer", "call_local")
func attach_to_grabber(grab_transform : Transform3D):
		print ("grabbo babbo")
		global_transform.basis = grab_transform.basis
		global_transform.origin = grab_transform.origin
		angular_velocity = Vector3.ZERO
		linear_velocity = Vector3.ZERO

@rpc("any_peer", "call_local")
func apply_impulse_rpc(impulse : Vector3):
	apply_central_impulse(impulse)
