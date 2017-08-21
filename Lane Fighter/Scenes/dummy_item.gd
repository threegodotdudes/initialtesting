extends Node2D

var value = 1

func _ready():
	if get_owner() != null:
		get_owner().coins_total += value
	
	get_node("Sprite/Area2D").connect("body_enter",self, "_collect_coin")
	

func _collect_coin( body ):
	if get_node("AnimationPlayer").get_current_animation() != "collect":
		if get_owner() != null:
			get_owner().coins_collected += value
		print(get_owner().coins_collected)
		get_node("AnimationPlayer").play("collect")

