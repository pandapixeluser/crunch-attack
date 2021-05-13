extends Node2D

#declarations
var target_file = load("res://Target.tscn") #load the Target Scene
var rng = RandomNumberGenerator.new()
var targetno = 20 #number of targets to spawn at start
var target_delay = 3
var points_per_target = 50
export var points = 0
var points_string = "Points: {points}" 
var gametime = 120
var gametime_int 
var gametime_string = "Time: {time}"

func spawn_target(): #Spawn a target in a random location within the box
	var target = target_file.instance()
	add_child(target)
	target.position = Vector2(rng.randi_range(50,4550),rng.randi_range(50,2450))

func _ready():
	rng.randomize()
	while targetno > 0:
		targetno -= 1
		spawn_target()

func target_hit(): #this is called when a target hits, spawns a new target after target_delay, and adds points_per_target to points
	Global.points += points_per_target
	yield(get_tree().create_timer(target_delay), "timeout")
	spawn_target()
func _process(delta):
	gametime -= delta
	gametime_int = floor(gametime)
	var formatted_points_string = points_string.format({"points": Global.points})
	get_node("RichTextLabel").set_text(formatted_points_string)
	var formatted_gametime_string = gametime_string.format({"time": gametime_int})
	get_node("RichTextLabel/RichTextLabel").set_text(formatted_gametime_string)
	get_node("RichTextLabel").set_position(get_node("Player").position - Vector2(1000, 600))
	if gametime_int == -1:
		get_tree().change_scene("res://EndScreen.tscn")
