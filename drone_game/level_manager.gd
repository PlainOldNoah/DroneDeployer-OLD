extends Node2D

var slug_path := preload("res://lifeforms/slug.tscn")

func _ready():
	spawn_enemy()
	get_rand_pos()

func spawn_enemy():
	var enemy_scene:Node = slug_path.instance()
	self.add_child(enemy_scene)
	enemy_scene.global_position = Vector2(50, 50)


var rng:RandomNumberGenerator = RandomNumberGenerator.new()
func get_rand_pos() -> Vector2:
	var map_size:Vector2 = OS.window_size
	
	var generated:Vector2 = Vector2(rng.randi_range(0, 1024), rng.randi_range(0, 600))
	print(map_size)
	return Vector2.ZERO
