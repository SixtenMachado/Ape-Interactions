extends NetworkRigidBody
class_name UsableItem

signal used

@rpc("any_peer", "call_local")
func use():
	used.emit()

func consume():
	queue_free()
