extends Node2D

var health = 50

func hit(damage):
  health -= damage

func _process(_delta):
  if health <= 0:
    queue_free()
