extends StaticBody2D

func hit():
	get_parent().target_hit()
	queue_free()
