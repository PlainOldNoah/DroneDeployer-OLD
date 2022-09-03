extends Node2D

onready var map := $TestingMap
onready var spawn_clock:Timer = $SpawnClock

var slug_path := preload("res://lifeforms/slug.tscn")
var exp_path := preload("res://objects/exp.tscn")
var rng:RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	Global.level_manager = self
	rng.randomize()


# Begins spawning enemies after int seconds
func start_spawn_clock(seconds:int):
	spawn_enemy_cell(1)
	spawn_clock.start(seconds)
	yield(spawn_clock, "timeout")
	start_spawn_clock(seconds)


# Stops the spawn clock
func stop_spawn_clock():
	spawn_clock.stop()


# Gets the list of spawnable tiles and randomly selects one to spawn an enemy 'count' number of times
func spawn_enemy_cell(count:int):
#	var tile_map:TileMap = get_node("TestingMap")
	var tiles:Array = map.get_used_cells_by_id(0)
	for i in count:
		var rand_key:int = rng.randi_range(0, tiles.size() - 1)
		var spawn_point:Vector2 = map.map_to_world(tiles[rand_key]) + (Vector2.ONE * (Global.tile_size / 2) + map.global_position)
		spawn_enemy(spawn_point)


# Creates a new enemy scene at the specified position
func spawn_enemy(pos:Vector2):
	var enemy_scene:Node = slug_path.instance()
	self.add_child(enemy_scene)
	enemy_scene.init(pos)


# Places exp where lifeform died at
func lifeform_died(lifeform:Node):
	var exp_scene:Node = exp_path.instance()
	self.add_child(exp_scene)
	exp_scene.global_position = lifeform.global_position
