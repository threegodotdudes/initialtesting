extends StaticBody2D

var hazard = preload("energy_projectile.tscn")
var attack_period = 0.15
var speed = 750
export var is_random = 1

func _ready():
	set_fixed_process(true)
	get_node("Timer").set_wait_time(attack_period)
	get_node("Timer").set_one_shot(true)
	get_node("Timer").set_fixed_process(true)
	get_node("Timer").start()
	
func _fixed_process(delta):
	if !get_node("Timer").is_processing():
		var angle = randf()*PI/6
		var random_attack = hazard.instance()
		get_parent().add_child(random_attack)
		random_attack.set_pos(get_node("Position2D").get_global_pos())
		random_attack.set_collision_mask(1 + 4 + 1024 + 2048)
		random_attack.get_node("Particles2D").set_blend_mode(BLEND_MODE_ADD)
		if is_random == 1:
			random_attack.yspeed = -speed*sin(angle + 75*PI/180+ self.get_rot())
			random_attack.xspeed = speed*cos(angle + 75*PI/180 + self.get_rot())
		else:
			random_attack.yspeed = -speed*sin(PI/2+ self.get_rot())
			random_attack.xspeed = speed*cos(PI/2 + self.get_rot())
		random_attack.grav = 20
		get_node("Timer").set_wait_time(attack_period)
		get_node("Timer").set_one_shot(true)
		get_node("Timer").set_fixed_process(true)
		get_node("Timer").start()
	
