extends AnimationTree
class_name ApeAnimations

@export var ape : ApeBody

@export_category("export vars for network reasons")
@export var on_floor : bool

func  _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	on_floor = ape.is_on_floor()
