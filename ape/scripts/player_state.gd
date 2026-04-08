extends Node
class_name PlayerState

enum State{
	NORMAL,
	RAGDOLL
}

@export var current_state := State.NORMAL
var ragdoll_current_time : float = 0
var ragdoll_getup_time : float = 4.0

func _process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	if current_state == State.RAGDOLL:
		ragdoll_current_time += delta
		if ragdoll_current_time > ragdoll_getup_time:
			ragdoll_current_time = 0
			current_state = State.NORMAL

func ragdoll():
	current_state = State.RAGDOLL
	ragdoll_current_time = 0
