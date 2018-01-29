extends Node2D

var value = 1
export var power_up_amount = 1.1

func _ready():
	if get_owner() != null:
		get_owner().coins_total += value
	
	get_node("Area2D").connect("body_enter",self, "_collect_coin")
	

func _collect_coin( body ):
	if get_node("AnimationPlayer").get_current_animation() != "collect":
		if get_owner() != null:
			get_owner().coins_collected += value

		get_node("AnimationPlayer").play("collect")
		body.get_node("turn").set_scale(body.get_node("turn").get_scale()*power_up_amount)
		body.character_speed = body.character_speed*power_up_amount
		body.jump_force = body.jump_force*power_up_amount