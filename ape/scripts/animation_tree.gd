extends AnimationTree
class_name ApeAnimations

@export var ape : ApeBody
@export var input : PlayerInput

@onready var state_machine := "res://new_animation_node_state_machine_playback.tres"

@export_category("export vars for network reasons")
@export var on_floor : bool
@export var crouch : bool

func  _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	on_floor = ape.is_on_floor()
	crouch = input.crouch
