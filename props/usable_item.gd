extends NetworkRigidBody
class_name UsableItem

signal used

func use():
	used.emit()

func consume():
	queue_free()
