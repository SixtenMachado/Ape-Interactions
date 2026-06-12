extends Node
class_name PlayerState

enum State{
	NORMAL,
	RAGDOLL,
	KNOCKOUT
}

var hungry := true
var satiation : float
var satiation_cap : float = 500

@export var base_health : float = 6
@export var debug_health_label : Label3D
var health : float
var health_floor : float = -20
var minimum_knockout_time : float = 3

@export var current_state := State.NORMAL
var ragdoll_current_time : float = 0
var ragdoll_getup_time : float = 4.0

var right_hand_grab : bool
var left_hand_grab : bool

func _ready() -> void:
	health = base_health

func _process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	if current_state == State.RAGDOLL:
		ragdoll_current_time += delta
		if ragdoll_current_time > ragdoll_getup_time:
			ragdoll_current_time = 0
			current_state = State.NORMAL
	
#	Hunger stuff
	if satiation > 0:
		hungry = false
		satiation -= delta
	else: hungry = true
	Gamestate.vignette.display(hungry)
	
#	Health stuff
	health = clampf(health + (delta * (2 - float(hungry))), health_floor, base_health)
	debug_health_label.text = str(health)
	if current_state == State.KNOCKOUT and health >= 0:
		current_state = State.NORMAL
	
func ragdoll(override_time : float = -1):
	current_state = State.RAGDOLL
	if override_time != -1:
		ragdoll_current_time = ragdoll_getup_time - override_time
	else:
		ragdoll_current_time = 0

func take_damage(damage : float):
	health -= roundf(damage - (health * float(health < 0)))
	if health < 0:
		if current_state != State.KNOCKOUT:
			current_state = State.KNOCKOUT
			#Make sure we're always knocked out for a few seconds so we don't get weird unsatisfying KOs
			health = clampf(health, health_floor, -minimum_knockout_time)
			
func eat(nutritional_value : float):
	satiation += nutritional_value
	satiation = clampf(satiation, 0, satiation_cap)
