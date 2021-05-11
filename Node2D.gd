extends Node2D

class_name player

	#variables

var yaccel = 0
var xaccel = 0
var yveloc = 0
var xveloc = 0
var yintent
var xintent
var delta

func accelcurve(intent,cvelocity):
	var vdif = abs(cvelocity - intent)
	return (vdif ^ 2)

func direction(intent):
	return intent/(abs(intent))

func velocity():
	delta = get_physics_process_delta_time()
	yintent = int (Input.is_action_pressed("move_up"))  - int (Input.is_action_pressed("move_down"))
	xintent = int (Input.is_action_pressed("move_right")) - int (Input.is_action_just_pressed("move_left"))
	xveloc += accelcurve(xintent,xveloc) * direction(xintent) * delta
	yveloc += accelcurve(yintent,yveloc) * direction(yintent) * delta
	return Vector2(xveloc,yveloc)
