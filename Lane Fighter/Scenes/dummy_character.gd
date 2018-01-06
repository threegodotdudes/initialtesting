extends RigidBody2D

		#Variables
var character_speed = 700
var character_acceleration = 5
var character_air_acceleration = 2
var jump_force = 700
var jump_ability = 2
var raycast_down = null
var turn_node = null
var anim_player = null
var anim_blend = 0.2
var anim_speed = 1
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

		#Movement Function with linear interpolation
func move(speed, acceleration, delta):
	current_speed.x = lerp(current_speed.x, speed, acceleration*delta)
	set_linear_velocity(Vector2(current_speed.x, get_linear_velocity().y))

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

		#Counter for stopping inputs. Called in animations
func waiting_function(time):
	get_node("Wait_timer").set_wait_time(time)
	get_node("Wait_timer").set_one_shot(true)
	get_node("Wait_timer").set_fixed_process(true)
	get_node("Wait_timer").start()

func hit_check():
	body_list = get_node("turn/a1").get_overlapping_bodies()
	print(body_list)
	if body_list.size() != 0:
		print("hitto")
		body_list[0].apply_impulse(Vector2(0,0),Vector2(2000*orientation,2000))
	
	
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
	if InputEvent.KEY and !event.is_echo() and !get_node("Wait_timer").is_processing():
		if event.is_action_pressed("ui_up") and jumping > 0:
			set_axis_velocity(Vector2(0,-jump_force))
			jumping -= 1
			print("jumping")
			current_action = "jumping"
		
				#Inputs for ground state
		if state_current == "ground" and waiting != true:
			if event.is_action_pressed("light_attack"):
				if current_action == "a1" and get_node("Action_timer").is_processing():
					print("a2")
					anim_player.queue("light_attack")
					current_action = "a2"
					get_node("Action_timer").start()
				elif current_action == "a2" and get_node("Action_timer").is_processing():
					print("a3")
					anim_player.queue("light_attack")
					current_action = "a0"
				elif current_action == "a5" and get_node("Action_timer").is_processing():
					print("a6")
					anim_player.queue("light_attack")
					current_action = "a0"
				elif current_action == "a8" and get_node("Action_timer").is_processing():
					print("a9")
					anim_player.queue("light_attack")
					current_action = "a9"
					get_node("Action_timer").start()
				elif current_action == "a9" and get_node("Action_timer").is_processing():
					print("a10")
					anim_player.queue("light_attack")
					current_action = "a0"
				elif current_action == "a12" and get_node("Action_timer").is_processing():
					print("a13")
					anim_player.queue("light_attack")
					current_action = "a0"
				else:
					print("a1")
					anim_player.play("light_attack")
					current_action = "a1"
					get_node("Action_timer").set_one_shot(true)
					get_node("Action_timer").set_wait_time(action_time)
					get_node("Action_timer").set_fixed_process(true)
					get_node("Action_timer").start()
				
			if event.is_action_pressed("heavy_attack"):
				if current_action == "a1" and get_node("Action_timer").is_processing():
					print("a5")
					anim_player.queue("heavy_attack")
					current_action = "a5"
					get_node("Action_timer").start()
				elif current_action == "a2" and get_node("Action_timer").is_processing():
					print("a4")
					anim_player.queue("heavy_attack")
					current_action = "a0"
				elif current_action == "a5" and get_node("Action_timer").is_processing():
					print("a7")
					anim_player.queue("heavy_attack")
					current_action = "a0"
				elif current_action == "a8" and get_node("Action_timer").is_processing():
					print("a12")
					anim_player.queue("heavy_attack")
					current_action = "a12"
					get_node("Action_timer").start()
				elif current_action == "a9" and get_node("Action_timer").is_processing():
					print("a11")
					anim_player.queue("heavy_attack")
					current_action = "a0"
				elif current_action == "a12" and get_node("Action_timer").is_processing():
					print("a14")
					anim_player.queue("heavy_attack")
					current_action = "a0"
				else:
					print("a8")
					anim_player.play("heavy_attack")
					current_action = "a8"
					get_node("Action_timer").set_one_shot(true)
					get_node("Action_timer").set_wait_time(action_time)
					get_node("Action_timer").set_fixed_process(true)
					get_node("Action_timer").start()
			if event.is_action_pressed("ui_down"):
				print("block")
				current_action = "a0"
			
				#Inputs for air state
		if state_current == "air":
					#Doube Tap Down to Fall Faster
			if event.is_action_pressed("ui_down"):
				self.apply_impulse(Vector2(0,0),Vector2(0,1000))
				print("dive")

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
	
	if state_current == "ground":
		ground_state(delta)
	elif state_current == "air":
		air_state(delta)
	
	if anim_current != anim_next:
		anim_next = anim_current
		anim_player.play(anim_current, anim_blend, anim_speed)

		#This part is called when the character enters ground_state
func ground_state(delta):
	if left_bttn and right_bttn != true and down_bttn != true:
		move(-character_speed, character_acceleration, delta)
		orientation_next = "left"
		anim_current = "running"
		anim_blend = 0.2
		anim_speed = 2
	elif right_bttn and left_bttn != true and down_bttn != true:
		move( character_speed, character_acceleration, delta)
		orientation_next = "right"
		anim_current = "running"
		anim_blend = 0.2
		anim_speed = 2
	else:
		move(0, character_acceleration, delta)
		anim_current = "idle"
		anim_blend = 0.2
		anim_speed = 0.5
	turn_behaviour()
	
	if !is_on_ground():
		state_next = "air"

		#This part is called when the character is in air_state
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
	
	if is_on_ground():
		state_next = "ground"
		jumping = jump_ability
		
	if get_linear_velocity().y < 0:
		anim_current = "jump"
	else:
		anim_current = "fall" 
