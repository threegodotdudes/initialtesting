extends Area2D

var xspeed = 1000
var direction = 1
var yspeed = -50
var grav = 3
var xpos
var ypos
var force = 500
var bodies
var weight

func _ready():
	set_fixed_process(true)
	self.connect("body_enter",self, "_disappear")

func _fixed_process(delta):
	xpos = self.get_global_pos().x
	ypos = self.get_global_pos().y
	if direction == -1 :
		get_node("Particles2D").set_flip_h(true)
	else:
		get_node("Particles2D").set_flip_h(true)
	self.set_pos(Vector2(xpos + xspeed*direction*delta, ypos + yspeed*delta))
	yspeed += grav
	
func _disappear(body):
	bodies = self.get_overlapping_bodies()[0]
	if bodies.is_type("RigidBody2D"):
		weight = bodies.get_weight()
		print(weight)
		bodies.apply_impulse(Vector2(0,0),Vector2(0,-30*weight))
	self.queue_free()