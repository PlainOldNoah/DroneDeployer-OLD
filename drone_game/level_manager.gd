extends Node2D

var slug_path := preload("res://lifeforms/slug.tscn")

func _ready():
	rng.randomize()


func _input(event):
	if event.is_action_pressed("ui_accept"):
#		for i in 100:
#		spawn_enemy_cell(1)
		start_spawn_clock(2)
#			spawn_enemy(get_rand_pos())

func start_spawn_clock(seconds:int):
	yield(get_tree().create_timer(seconds), "timeout")
	spawn_enemy_cell(1)
	start_spawn_clock(seconds)


# Gets the list of spawnable tiles and randomly selects one to spawn an enemy 'count' number of times
func spawn_enemy_cell(count:int):
	var tile_map:TileMap = get_parent().get_node("TestingMap")
	var tiles:Array = tile_map.get_used_cells_by_id(0)
	for i in count:
		var rand_key:int = rng.randi_range(0, tiles.size() - 1)
		var spawn_point:Vector2 = tile_map.map_to_world(tiles[rand_key]) + (Vector2.ONE * (Global.tile_size / 2))
		spawn_enemy(spawn_point)


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
