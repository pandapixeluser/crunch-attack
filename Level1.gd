extends Node2D

#standard variables
var thread = Thread.new()
var wave_1_enemy_clusters = 2
var wave_1_enemies_per_cluster = 5
#enemy variables
var Enemy1 = load("res://Enemy.tscn")

#wave functions
func wave_1():
  while wave_1_enemy_clusters > 0:
    wave_1_enemy_clusters -= 1
    var enemy_cluster_location = random_spawn_location()
    spawn_enemy_cluster(wave_1_enemies_per_cluster,enemy_cluster_location)


#miscellaneous functions
func random_spawn_location():
  var spawn_zone = rng.randi_range(1,4)
  if spawn_zone = 1:
    return Vector2(rng.randi_range(-2200,-2000),rng.randi_range(-1000,1000))
  elif spawn_zone = 2:
    return Vector2(rng.randi_range(2000,2200),rng.randi_range(-1000,1000))
  elif spawn_zone = 3:
    return Vector2(rng.randi_range(-2200, 2200),rng.randi_range(-1000,-900))
  elif spawn_zone = 4:
    return Vector2(rng.randi_range(-2200, 2200), rng.randi_range(900,1000))

func spawn_enemy_cluster(enemies_in_cluster, cluster_location):
  var enemies_left_in_cluster = enemies_in_cluster
  while enemies_left_in_cluster > 1:
    enemies_left_in_cluster -= 1
    var enemy_position = cluster_location + Vector2(cos((2*pi*enemies_left_in_cluster)/enemies_in_cluster)*enemy_cluster_radius,sin((2*pi*enemies_left_in_cluster)/enemies_in_cluster)*enemy_cluster_radius)
    spawn_enemy(Enemy1)
func spawn_enemy(enemy, enemy_position):


#active functions
func _ready():
  rng.randomize()
  thread.start(self, "wave_1")
