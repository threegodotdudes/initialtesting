extends RigidBody2D

		#Variables
var character_speed = 500
var character_acceleration = 10
var character_air_acceleration = 5
var jump_force = 700
var jump_ability = 1
var raycast_down = null
var turn_node = null
var anim_player = null
var anim_blend = 0.2
var anim_speed = 1
var anim_running_speed = anim_speed*1.5
var anim_light_attack_speed = anim_speed*2
var jumping = jump_ability
var light_attack_force = 700
var left_bttn
var right_bttn
var down_bttn
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
var move_time = 0.5
var current_action
var action_time = 0.5
var waiting = false
var wait_time = 0.5
var body_list
var orientation = 1
var state_1 = "grounded"
var state_2 = "idle"
var resource_1_min = float(0)
var resource_1_max = float(100)
var resource_1_regen_rate = (resource_1_max - resource_1_min)/500
var resource_1_current = resource_1_max

var chip = preload("energy_projectile.tscn")
var bombard = preload("energy_projectile.tscn")

		#Movement Function with linear interpolation
func move(speed, acceleration, delta):
	current_speed.x = lerp(current_speed.x, speed, acceleration*delta)
	#set_linear_velocity(Vector2(current_speed.x, get_linear_velocity().y))
	set_axis_velocity(Vector2(current_speed.x, 0))
	
		#This Function Makes Character Face Left or Right
func turn_behaviour():
	if orientation_current != orientation_next:
		turn_node.set_scale(turn_node.get_scale() * Vector2(-1,1))
		orientation = orientation*-1

		#This part checks for ground state
func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false

		#Counter for stopping inputs. Called in animations to prevent button mashing
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
	
func hit_check():
	if anim_player.get_current_animation() == "light_attack":
		body_list = get_node("turn/a1").get_overlapping_bodies()
		if body_list.size() != 0 and body_list[0].is_type("RigidBody2D"):
			print("hitto")
			body_list[0].apply_impulse(Vector2(0,0),Vector2(150*orientation,-550))
			body_list[0].set_angular_velocity(-200*orientation)
	elif anim_player.get_current_animation() == "heavy_attack":
		body_list = get_node("turn/a2").get_overlapping_bodies()
		if body_list.size() != 0 and body_list[0].is_type("RigidBody2D"):
			print("heavy hitto")
			body_list[0].apply_impulse(Vector2(0,0),Vector2(1000*orientation,-350))
			body_list[0].set_angular_velocity(200*orientation)
	elif anim_player.get_current_animation() == "taunt":
		body_list = get_node("turn/a3").get_overlapping_bodies()
		if body_list.size() != 0:
			print("taunt hitto")
			body_list[0].apply_impulse(Vector2(0,0),Vector2(-1500*orientation,-500))
			body_list[0].set_angular_velocity(-200*orientation)
	
		#Ready Function
func _ready():
	get_node("Camera2D").set_zoom(get_node("Camera2D").get_zoom() * get_node("/root/global").viewport_scale)
	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)
	turn_node = get_node("turn")
	anim_player = get_node("turn/AnimationPlayer")
	set_fixed_process(true)
	set_process_input(true)

		#Input Events
func _input(event):
	if InputEvent.KEY and !event.is_echo() and !get_node("Wait_timer").is_processing() and !get_node("Action_timer").is_processing():
		if event.is_action_pressed("ui_up") and jumping > 0:
			set_axis_velocity(Vector2(0,-jump_force))
			jumping -= 1
		
		if event.is_action_pressed("light_attack") and state_1 == "grounded" :
			state_2 = "mid_action"
			anim_player.play("light_attack", anim_blend, anim_light_attack_speed)
			action_time(anim_player.get_current_animation_length()/2)
		
		if event.is_action_pressed("heavy_attack") and state_1 == "grounded":
			state_2 = "mid_action"
			anim_player.play("heavy_attack", anim_blend, anim_light_attack_speed)
			action_time(anim_player.get_current_animation_length()/2)
		
		if event.is_action_pressed("taunt") and state_1 == "grounded":
			state_2 = "mid_action"
			anim_player.play("taunt", anim_blend, anim_light_attack_speed)
			action_time(anim_player.get_current_animation_length()/2)
			
		if event.is_action_pressed("ranged_chip_attack"):
			state_2 = "mid_action"
			resource_1_current = resource_1_current - 5
			var chip_attack = chip.instance()
			get_parent().add_child(chip_attack)
			chip_attack.set_pos(get_node("turn/Position2D").get_global_pos())
			chip_attack.direction = chip_attack.direction*orientation
			anim_player.play("chip_attack", 0, anim_speed)
			action_time(anim_player.get_current_animation_length()/6)

		if event.is_action_pressed("ranged_bombard_attack"):
			state_2 = "mid_action"
			resource_1_current = resource_1_current - 10
			var bombard_attack = bombard.instance()
			bombard_attack.set_pos(get_node("turn/Position2D").get_global_pos())
			bombard_attack.direction = bombard_attack.direction*orientation
			bombard_attack.yspeed = -1000
			bombard_attack.xspeed = 250
			bombard_attack.grav = 15
			get_parent().add_child(bombard_attack)
			anim_player.play("bombard_attack", 0, anim_speed*5)
			action_time(anim_player.get_current_animation_length())

				#Inputs for air state
		if state_1 == "mid_air":
					#Doube Tap Down to Fall Faster
			if event.is_action_pressed("ui_down"):
				self.apply_impulse(Vector2(0,0),Vector2(0,1000))

		#Main Loop
func _fixed_process(delta):
	state_prev = state_current
	state_current = state_next
	orientation_prev = orientation_current
	orientation_current = orientation_next
	set_rot(0)
	left_bttn = Input.is_action_pressed("ui_left")
	right_bttn = Input.is_action_pressed("ui_right")
	down_bttn = Input.is_action_pressed("ui_down")
	light_attack_bttn = Input.is_action_pressed("light_attack")
	heavy_attack_bttn = Input.is_action_pressed("heavy_attack")
	taunt_bttn = Input.is_action_pressed("taunt")
	
	resource_1(delta)
	
	#print(state_1)
	#print(state_2)
	
	if is_on_ground():
		state_1 = "grounded"
		jumping = jump_ability
		ground_state(delta)
	else:
		state_1 = "mid_air"
		jumping = 0  #temporary solution to multiple jumps
		air_state(delta)

		#This part is called when the character enters ground_state
func ground_state(delta):
	if get_node("Action_timer").is_processing():
		state_2 = "mid_action"
	
	if state_2 == "idle":
		if anim_player.get_current_animation() != "idle":
			anim_player.play("idle", anim_blend, anim_speed)
	elif state_2 == "moving":
		if anim_player.get_current_animation() != "running":
			anim_player.play("running", anim_blend, anim_running_speed)

	if left_bttn and right_bttn != true and down_bttn != true and state_2 != "mid_action":
		state_2 = "moving"
		move(-character_speed, character_acceleration, delta)
		orientation_next = "left"
	elif right_bttn and left_bttn != true and down_bttn != true and state_2 != "mid_action":
		state_2 = "moving"
		move( character_speed, character_acceleration, delta)
		orientation_next = "right"
	elif down_bttn and state_2 != "mid_action":
		anim_player.play("block")
		move(0, character_acceleration, delta)
	elif !get_node("Action_timer").is_processing():
		state_2 = "idle"
		move(0, character_acceleration, delta)
	else:
		move(0, character_acceleration, delta)


	turn_behaviour()
	

		#This part is called when the character is in air_state
func air_state(delta):
	if get_linear_velocity().y < 0:
		state_2 = "rising"
		if anim_player.get_current_animation() != "jump":
			anim_player.play("jump", anim_blend, anim_speed)
	elif get_linear_velocity().y > 0:
		state_2 = "falling"
		if anim_player.get_current_animation() != "fall":
			anim_player.play("fall", anim_blend, anim_speed)
	else:
		state_2 = "floating"
	
	if left_bttn and right_bttn != true:
		move(-character_speed, character_air_acceleration, delta)
		orientation_next = "left"
	elif right_bttn and left_bttn != true:
		move( character_speed, character_air_acceleration, delta)
		orientation_next = "right"
	else:
		move(0, character_air_acceleration, delta)
	turn_behaviour()

func resource_1(delta):
	if resource_1_current < 100:
		resource_1_current = resource_1_current + resource_1_regen_rate
	get_owner().get_node("gui/Resource1_outline/Resource1").set_scale(Vector2(1*resource_1_current/resource_1_max,1))
