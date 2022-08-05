extends Node2D

var slug_path := preload("res://lifeforms/slug.tscn")

func _ready():
	rng.randomize()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		for i in 1:
			spawn_enemy(get_rand_pos())

func spawn_enemy(pos:Vector2):
	var enemy_scene:Node = slug_path.instance()
	self.add_child(enemy_scene)
	enemy_scene.init(pos)


var rng:RandomNumberGenerator = RandomNumberGenerator.new()
func get_rand_pos() -> Vector2:
	var map_size:Vector2 = OS.window_size
	
	var rand_num:int = rng.randi_range(1, 4)
	
	print("Spawning")
	
	match rand_num:
		1: #Left
			return(Vector2(0, rng.randi_range(0, map_size.y)))
		2: #Right
			return(Vector2(map_size.x, rng.randi_range(0, map_size.y)))
		3: #Top
			return(Vector2(rng.randi_range(0, map_size.x), 0))
		4: #Bottom
			return(Vector2(rng.randi_range(0, map_size.x), map_size.y))
		_:
			return Vector2.ZERO
