extends KinematicBody2D

#standard variables
var velocity = Vector2(0,0) #the current velocity
var acceleration = Vector2(0,0) #change in velocity as calculated by calculate_acceleration()
var intent = Vector2() #the intended velocity as decided by player
var velocity_defecit = Vector2(0,0) #difference between velocity and intent
var true_velocity = Vector2(0,0)  #velocity multiplied by speed
var friction = 0.1 #IMPORTANT: apply friction to velocity, NOT true_velocity for standardization's sake. If speed is changed friction will increase in proportion with it
var quick_stop_rate = 0.9 #the rate at which quick stop will slow the player
var velocity_floor = 0.15 #the velocity at which the engine will stop the player automatically
var mass = 1
var speed = 700


#acceleration curve functions
func active_accel(input): #active acceleration, where the player is actively trying to move.
	return input

func quick_stop(input): #quick stop, where the player is actively trying to stop their character
	print ("quick_stop called")
	if sign(input) == 1: 	#if the player is moving one way, accelerate the other at the defined quick_stop_rate
		return -quick_stop_rate
	elif sign(input) == -1:
		return quick_stop_rate
	elif input == 0:
		return 0
	else: 
		print("ERROR: quick_stop() error")

#miscellaneous functions
func get_inputs(): #find the player's inputs
	intent.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) #find x axis intent
	intent.y = (Input.get_action_strength("move_down") - (Input.get_action_strength("move_up"))) #find y axis intent
	
func calculate_acceleration(): ##calculates acceleration and automatically updates the variable "acceleration" when complete, returns null
	acceleration = Vector2(0,0) #reset acceleration from last frame by default
	if (Input.is_action_pressed("quick stop") == true): 	#if quickstop is pushed, ignore all else and use quick_stop function to define acceleration
		acceleration = Vector2(quick_stop(velocity.x), quick_stop(velocity.y))
	else:
		var movebuttons_total = (abs(intent.x) + abs(intent.y)) #total of all movement buttons
		velocity_defecit = intent - velocity
		if ((-0.1 > movebuttons_total) || (movebuttons_total > 0.1)): #check to see if the player is moving on either axis
			if ((intent.x != 0) && (sign(intent.x) == -sign(velocity.x))): #if they're trying to switch direction on x axis, apply quick stop to the x axis
				acceleration.x = quick_stop(velocity.x) 
			else:
				acceleration.x = active_accel(velocity_defecit.x) #if they're not trying to swtich direction, apply active acceleration curve
			if ((intent.y != 0) && (sign(intent.y) == -sign(velocity.y))):
				acceleration.y = quick_stop(velocity.y)
			else:
				acceleration.y = active_accel(velocity_defecit.y)
		elif abs(velocity.x) + abs(velocity.y) < velocity_floor: #if the player character is moving too slowly, and isn't trying to move, just stop the character
			velocity = Vector2(0,0)

#processing functions 
func _physics_process(delta): #final physics processing, called by engine
	var move_and_collide_output #variable to handle raw output of move_and_collide() without breaking true_velocity
	get_inputs() #call the get_inputs function
	velocity = Vector2(true_velocity.x / speed, true_velocity.y / speed) #find velocity based on previous frame's move_and_collide output
	calculate_acceleration() #call the calculate_acceleration function
	velocity += acceleration * delta
	true_velocity = velocity * speed
	move_and_collide_output = move_and_collide((true_velocity * delta))
	if move_and_collide_output != null:
		true_velocity = move_and_collide_output
