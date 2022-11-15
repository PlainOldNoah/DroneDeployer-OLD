class_name LevelManager
extends Node2D

export var barrier_width:int = 3

onready var current_map:TileMap = $CurrentMap
onready var barrier_top:CollisionShape2D = $LevelEdgeBarrier/BarrierTop
onready var barrier_bottom:CollisionShape2D = $LevelEdgeBarrier/BarrierBottom
onready var barrier_left:CollisionShape2D = $LevelEdgeBarrier/BarrierLeft
onready var barrier_right:CollisionShape2D = $LevelEdgeBarrier/BarrierRight



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
	
	move_barriers(area)
	generate_tiles()


func _input(event): #DEBUG
	if event.is_action_pressed("ui_page_up"):
		scale *= 1.25
	elif event.is_action_pressed("ui_page_down"):
		scale /= 1.25
	
	move_barriers(area)
	generate_tiles()


# Adjusts the size of the barriers to fit the current screen size and moves them into place
func move_barriers(area:Vector2):
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
	var num_tiles_x:int = ceil(area.x / (32.0 * scale.x))
	var num_tiles_y:int = ceil(area.y / (32.0 * scale.y))
	
	num_tiles_x = num_tiles_x + 1 if num_tiles_x % 2 == 1 else num_tiles_x
	num_tiles_y = num_tiles_y + 1 if num_tiles_y % 2 == 1 else num_tiles_y
	
	for i in num_tiles_x:
		for j in num_tiles_y:
			current_map.set_cell(i - num_tiles_x / 2, j - num_tiles_y / 2, 1)


# Finds a point around the edge of the map
func select_point() -> Vector2:
	var point:int = rng.randi_range(corners.front(), corners.back())
	if point <= corners[1]: # TOP
		return (Vector2(point, 0) - position) / scale
	elif point <= corners[2]: # RIGHT
		return (Vector2(area.x, point - corners[1]) - position) / scale
	elif point <= corners[3]: # BOTTOM
		return (Vector2(point - corners[2], area.y) - position) / scale
	elif point <= corners[4]: # LEFT
		return (Vector2(0, point - corners[3]) - position) / scale
	else:
		print_debug("ERROR: point not found on perimeter")
		return Vector2.ZERO


func spawn_enemy():
	var spawn_point:Vector2 = select_point()
	var enemy_inst:Node = slug_path.instance()
	enemy_inst.set_position(spawn_point)
	self.add_child(enemy_inst)


# Places exp where lifeform died at
func lifeform_died(lifeform:Node):
	var exp_scene:Node = exp_path.instance()
	self.add_child(exp_scene)
	exp_scene.global_position = lifeform.global_position


func test(): # DEBUG
	var test_obj = preload("res://objects/exp.tscn")
	for i in 500:
		var new_scn:Node = test_obj.instance()
		add_child(new_scn)
		new_scn.position = select_point()
