extends RigidBody2D
	
var character_speed = 700
var character_acceleration = 5
var character_air_acceleration = 2
var jump_force = 1000
var jump_ability = 2
var raycast_down = null
var turn_node = null
var anim_player = null
var anim_blend = 0.2
var anim_speed = 1
var jumping = jump_ability
	
var left_bttn
var right_bttn
var jump_bttn
var light_attack_bttn
var heavy_attack_bttn
var taunt_bttn
	
var current_speed = Vector2(0,0)
var state_prev = ""
var state_current = "" 
var state_next = "ground"
var orientation_prev = ""
var orientation_current = ""
var orientation_next = "right"
var anim_current = ""
var anim_next = ""
	
func move(speed, acceleration, delta):
	current_speed.x = lerp(current_speed.x, speed, acceleration*delta)
	set_linear_velocity(Vector2(current_speed.x, get_linear_velocity().y))

func turn_behaviour():
	if orientation_current != orientation_next:
		turn_node.set_scale(turn_node.get_scale() * Vector2(-1,1))

func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false
	
func _ready():
	get_node("Camera2D").set_zoom(get_node("Camera2D").get_zoom() * get_node("/root/global").viewport_scale)
	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)
	turn_node = get_node("turn")
	anim_player = get_node("turn/AnimationPlayer")
	set_fixed_process(true)
	
func _fixed_process(delta):
	state_prev = state_current
	state_current = state_next
	orientation_prev = orientation_current
	orientation_current = orientation_next
	set_rot(0)
	left_bttn = Input.is_action_pressed("ui_left")
	right_bttn = Input.is_action_pressed("ui_right")
	jump_bttn = Input.is_action_pressed("ui_up")
	light_attack_bttn = Input.is_action_pressed("light_attack")
	heavy_attack_bttn = Input.is_action_pressed("heavy_attack")
	taunt_bttn = Input.is_action_pressed("taunt_bttn")
	
	if state_current == "ground":
		ground_state(delta)
	elif state_current == "air":
		air_state(delta)
	
	if anim_current != anim_next:
		anim_next = anim_current
		anim_player.play(anim_current, anim_blend, anim_speed)
	
func ground_state(delta):
	jumping = jump_ability
	if left_bttn and right_bttn != true and light_attack_bttn != true:
		move(-character_speed, character_acceleration, delta)
		orientation_next = "left"
		anim_current = "running"
		anim_blend = 0.2
		anim_speed = 2
	elif right_bttn and left_bttn != true and light_attack_bttn != true:
		move( character_speed, character_acceleration, delta)
		orientation_next = "right"
		anim_current = "running"
		anim_blend = 0.2
		anim_speed = 2
	elif light_attack_bttn:
		move(0, character_acceleration, delta)
		anim_current = "light_attack"
		anim_blend = 0.2
		anim_speed = 1
	elif heavy_attack_bttn:
		move(0, character_acceleration, delta)
		anim_current = "heavy_attack"
		anim_blend = 0.2
		anim_speed = 1
	elif taunt_bttn:
		move(0, character_acceleration, delta)
		anim_current = "taunt"
		anim_blend = 0.2
		anim_speed = 1
	else:
		move(0, character_acceleration, delta)
		anim_current = "idle"
		anim_blend = 0.2
		anim_speed = 0.5
	turn_behaviour()
	
	if is_on_ground():
		if jump_bttn:
			set_axis_velocity(Vector2(0, -jump_force))
			jumping -= 1
	else:
		state_next = "air"
	
func air_state(delta):
	if left_bttn and right_bttn != true:
		move(-character_speed, character_air_acceleration, delta)
		orientation_next = "left"
	elif right_bttn and left_bttn != true:
		move( character_speed, character_air_acceleration, delta)
		orientation_next = "right"
	else:
		move(0, character_air_acceleration, delta)
	turn_behaviour()
	
	if jump_bttn and jumping > 0:
		set_axis_velocity(Vector2(0,-jump_force))
		jumping -= 1
	
	if is_on_ground():
		state_next = "ground"
		
	if get_linear_velocity().y < 0:
		anim_current = "jump"
	else:
		anim_current = "fall" 
