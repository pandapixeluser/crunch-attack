extends KinematicBody2D

class_name projectile 

var velocity = Vector2()

func _physics_process(delta):
	velocity = move_and_slide(velocity)
