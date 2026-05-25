extends GPUParticles3D
class_name YummyParticles

#TOCO: replace this with an autoload that emits a signal when player hunger changes
func _process(delta: float) -> void:
	if Gamestate.player:
		emitting = Gamestate.player.state.hungry
