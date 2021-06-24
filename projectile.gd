extends KinematicBody2D

class_name projectile

var velocity = Vector2()
var friction_rate = 0.002
func set_velocity(input): #setvar for velocity
	velocity = input

func friction(input):
	return -friction_rate*input #accelerate in opposite direction of velocity by defined friction_rate

func _ready():
	add_collision_exception_with(get_tree().get_root().get_node("Main").get_node("Player"))

func _physics_process(delta):
	var collision #variable to handle collisions
	collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit(Global.bullet_damage)
		get_parent().queue_free()
