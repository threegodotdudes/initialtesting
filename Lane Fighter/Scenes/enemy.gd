extends RigidBody2D

var character_speed = 400
var character_acceleration = 10
var character_air_acceleration = 5
var jump_force = 700
var jump_ability = 1
var raycast_down = null
var raycast_right = null
var raycast_left = null
var turn_node = null
var anim_player = null
var anim_blend = 0.2
var anim_speed = 1
var anim_running_speed = anim_speed*1.5
var jumping = jump_ability
var left_bttn
var right_bttn
var down_bttn
var jump_bttn
var current_speed = Vector2(0,0)
var state_prev = ""
var state_current = "" 
var state_next = "ground"
var orientation_prev = ""
var orientation_current = ""
var orientation_next = "right"
var anim_current = ""
var anim_next = ""
var orientation = 1
var state_1 = "grounded"
var state_2 = "idle"
var resource_1_min = float(0)
var resource_1_max = float(100)
var resource_1_regen_rate = (resource_1_max - resource_1_min)/500
var resource_1_current = resource_1_max

func _ready():
	raycast_down = get_node("RayCast2D")
	raycast_right = get_node("RayCast_right")
	raycast_left = get_node("RayCast_left")
	raycast_down.add_exception(self)
	raycast_right.add_exception(self)
	raycast_left.add_exception(self)
	turn_node = get_node("turn")
	anim_player = get_node("turn/AnimationPlayer")
	set_fixed_process(true)
	pass

func move(speed, acceleration, delta):
	current_speed.x = lerp(current_speed.x, speed, acceleration*delta)
	#set_linear_velocity(Vector2(current_speed.x, get_linear_velocity().y))
	set_axis_velocity(Vector2(current_speed.x, 0))

func turn_behaviour():
	if orientation_current != orientation_next:
		turn_node.set_scale(turn_node.get_scale() * Vector2(-1,1))
		orientation = orientation*-1

func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false

func wait_time(time):
	get_node("Wait_timer").set_wait_time(time)
	get_node("Wait_timer").set_one_shot(true)
	get_node("Wait_timer").set_fixed_process(true)
	get_node("Wait_timer").start()

func action_time(time):
	get_node("Action_timer").set_wait_time(time)
	get_node("Action_timer").set_one_shot(true)
	get_node("Action_timer").set_fixed_process(true)
	get_node("Action_timer").start()

func _fixed_process(delta):
	state_prev = state_current
	state_current = state_next
	orientation_prev = orientation_current
	orientation_current = orientation_next
	set_rot(0)

	if raycast_right.is_colliding():
		right_bttn
		print("go right")
	if raycast_left.is_colliding():
		left_bttn
		print("go left")
	
	#resource_1(delta)

	if is_on_ground():
		state_1 = "grounded"
		jumping = jump_ability
		ground_state(delta)
	else:
		state_1 = "mid_air"
		jumping = 0  #temporary solution to multiple jumps
		#air_state(delta)
		
		
func ground_state(delta):
	if get_node("Action_timer").is_processing():
		state_2 = "mid_action"
	
	if state_2 == "idle":
		if anim_player.get_current_animation() != "idle":
			#anim_player.play("idle", anim_blend, anim_speed)
			pass
	elif state_2 == "moving":
		if anim_player.get_current_animation() != "running":
			#anim_player.play("running", anim_blend, anim_running_speed)
			pass

	if  raycast_left.is_colliding() and down_bttn != true and state_2 != "mid_action":
		state_2 = "moving"
		move(-character_speed, character_acceleration, delta)
		orientation_next = "left"
	elif raycast_right.is_colliding() and down_bttn != true and state_2 != "mid_action":
		state_2 = "moving"
		move( character_speed, character_acceleration, delta)
		orientation_next = "right"
	elif down_bttn and state_2 != "mid_action":
		#anim_player.play("block")
		move(0, character_acceleration, delta)
	elif !get_node("Action_timer").is_processing():
		state_2 = "idle"
		move(0, character_acceleration, delta)
	else:
		move(0, character_acceleration, delta)


	turn_behaviour()