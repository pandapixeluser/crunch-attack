extends Timer

func _on_Timer_timeout():
	pass # Replace with function body.
	get_parent().queue_free()
