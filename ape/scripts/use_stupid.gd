extends Node
class_name UseStupid

@export var left : Grabbo
@export var right : Grabbo
@export var state : PlayerState

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use_left"):
		use(false)
	if event.is_action_pressed("use_right"):
		use(true)

func use(right_hand : bool):
	var grabbo : Grabbo
	if right_hand: grabbo = right
	else: grabbo = left
	
	if grabbo.held_item is Banana:
		state.eat(grabbo.held_item.nutritional_value)
		grabbo.held_item.consume()
		grabbo.held_item = null
		GameplayInterface.play_sound(load("res://audio/clink slurp.wav"))
	
	elif grabbo.held_item is UsableItem:
		var item = grabbo.held_item as UsableItem
		item.use.rpc()
