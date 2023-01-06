class_name LevelManager
extends Node2D

const AUTO_FILL_TILE:int = 0

export var barrier_width:int = 3
export var enemy_level_edge_offset:int = 1
export var enemy_spawn_subdivisions:int = 1

onready var current_map:TileMap = $CurrentMap
onready var barrier_top:CollisionShape2D = $LevelEdgeBarrier/BarrierTop
onready var barrier_bottom:CollisionShape2D = $LevelEdgeBarrier/BarrierBottom
onready var barrier_left:CollisionShape2D = $LevelEdgeBarrier/BarrierLeft
onready var barrier_right:CollisionShape2D = $LevelEdgeBarrier/BarrierRight
onready var enemy_spawn_clock:Timer = $EnemySpawnClock

var area:Vector2 = Vector2.ZERO
var perimeter:int = 0
var corners:Array = [0]

var slug_path := preload("res://lifeforms/slug.tscn")
var exp_path := preload("res://objects/exp.tscn")
var rng:RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	Global.level_manager = self
	rng.randomize()
	area = get_parent().rect_size
	perimeter = (2 * area.x) + (2 * area.y)
	position = area / 2 # Center the scene
	
	for i in 2:
		corners.append(corners.back() + area.x)
		corners.append(corners.back() + area.y)
	
	move_barriers()
	generate_tiles()


func _input(event): #DEBUG
	if event.is_action("ui_page_up"):
		scale *= 1.025
	elif event.is_action("ui_page_down"):
		scale /= 1.025
	
	move_barriers()
	generate_tiles()


# Adjusts the size of the barriers to fit the current screen size and moves them into place
func move_barriers():
	var height:int = (area.y / scale.y) / 2 # Top to bottom
	var width:int = (area.x / scale.x) / 2 # Left to Right

	barrier_top.shape.extents = Vector2(width, barrier_width)
	barrier_top.position = Vector2(0, -height)

	barrier_bottom.shape.extents = Vector2(width, barrier_width)
	barrier_bottom.position = Vector2(0, height)

	barrier_left.shape.extents = Vector2(barrier_width, height)
	barrier_left.position = Vector2(-width, 0)

	barrier_right.shape.extents = Vector2(barrier_width, height)
	barrier_right.position = Vector2(width, 0)


# Places tiles to fill up the current visiable area
func generate_tiles():
	var tilemap_scale:Vector2 = current_map.scale
	var num_tiles_x:int = ceil(area.x / (32.0 * scale.x * tilemap_scale.x))
	var num_tiles_y:int = ceil(area.y / (32.0 * scale.y * tilemap_scale.y))
	
	num_tiles_x = num_tiles_x + 1 if num_tiles_x % 2 == 1 else num_tiles_x
	num_tiles_y = num_tiles_y + 1 if num_tiles_y % 2 == 1 else num_tiles_y
	
	for i in num_tiles_x:
		for j in num_tiles_y:
			current_map.set_cell(i - num_tiles_x / 2, j - num_tiles_y / 2, AUTO_FILL_TILE)


func get_lvl_edge_point(edge_offset:int=0, sub_divisions:int=0) -> Vector2:
	var point:Vector2 = Vector2(rng.randi_range(edge_offset, area.x), rng.randi_range(edge_offset, area.y))
	sub_divisions = max(1, sub_divisions - 1)
	
	if randf() > 0.5:
		# Top and Bottom
		point = point.snapped(Vector2((area.x/sub_divisions), area.y))
		point.y = point.y + edge_offset if sign(point.y) == 1 else point.y - edge_offset
	else:
		# Left and Right
		point = point.snapped(Vector2(area.x, area.y/sub_divisions))
		point.x = point.x + edge_offset if sign(point.x) == 1 else point.x - edge_offset
	
	return point - position


# Creates an enemy instance somewhere along the edge of the level
func spawn_enemy():
	var spawn_point:Vector2 = get_lvl_edge_point(enemy_level_edge_offset, enemy_spawn_subdivisions)
	
	var enemy_inst:Node = slug_path.instance()
	enemy_inst.set_position(spawn_point)
	self.add_child(enemy_inst)


# Places exp where lifeform died at
func lifeform_died(lifeform:Node):
	var exp_scene:Node = exp_path.instance()
	self.add_child(exp_scene)
	exp_scene.global_position = lifeform.global_position


# Starts the timer that spawns enemies
func start_enemy_spawning(wave_delay:int):
	enemy_spawn_clock.wait_time = wave_delay
	spawn_enemy() # Spawns before time begins
	enemy_spawn_clock.start()


# Stops the timer that spawns enemies
func stop_enemy_spawning():
	enemy_spawn_clock.stop()


func _on_EnemySpawnClock_timeout():
	spawn_enemy()
