extends AudioStreamPlayer3D


func _on_drum_body_entered(body: Node) -> void:
	if Vector3($"..".linear_velocity).length() > 0:
		play()
		print("bonque")


func _on_drum_used() -> void:
	print("drum that")
	play()
