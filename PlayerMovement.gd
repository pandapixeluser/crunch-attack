extends KinematicBody2D

class_name player
	#variables

var yaccel = 0
var xaccel = 0
var yveloc = 0
var xveloc = 0
var yintent
var xintent
var velocity = Vector2()
var fixdelta
var speed = 15

func accelcurve(intent, cvelocity):
	var vdif = (intent - cvelocity)
	if (vdif > 0):
		 return pow(vdif,2)
	elif (vdif < 0):
		return -pow(vdif,2)
	elif (vdif == 0):
		return 0
	else:
		print("error in accelcurve()")
		
func shoot():
	var projectile = load("res://Projectile.tscn")
	var bullet = projectile.instance()
	get_tree().get_root().get_node("Main").add_child(bullet)
	bullet.transform = transform 
	var relative_bullet_speed = 400
	var global_bullet_speed = Vector2(cos(rotation) * relative_bullet_speed,sin(rotation) * relative_bullet_speed)
	bullet.get_node("KinematicBody2D").velocity = Vector2(velocity[0]*speed + global_bullet_speed.x,velocity[1]*speed + global_bullet_speed.y)
	print (bullet.get_node("KinematicBody2D").velocity) 
	print (velocity*speed)

func find_velocity():
	xveloc = velocity[0]/speed
	yveloc = velocity[1]/speed
	fixdelta = get_physics_process_delta_time()
	yintent = -float (Input.is_action_pressed("move_up"))  + float (Input.is_action_pressed("move_down"))
	xintent = float (Input.is_action_pressed("move_right")) - float (Input.is_action_pressed("move_left"))
	xveloc += accelcurve(xintent,xveloc) * fixdelta
	yveloc += accelcurve(yintent,yveloc) * fixdelta
	if (((-0.1 < xveloc) && (xveloc < 0.1)) && ((-0.1 < xintent) && (xintent < 0.1))) && (((-0.1 < yveloc) && (yveloc < 0.1)) && ((-0.1 < yintent) && (yintent < 0.1))):
		xveloc = 0
		yveloc = 0
		#print("STOP")
	velocity = Vector2(xveloc,yveloc) * speed
	#print("x velocity curve=",accelcurve(xintent,xveloc))
	#print("y velocity curve=",accelcurve(yintent,yveloc))
	#print("x velocity=",xveloc)
	#print("y velocity=",yveloc)

func get_actions():
	if Input.is_action_just_pressed("shoot"):
		shoot()


func _physics_process(_delta):
	find_velocity()
	get_actions()
	var collision = move_and_collide(velocity)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	rotation = get_global_mouse_position().angle_to_point(position)
