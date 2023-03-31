extends Control

@onready var current_map := $Centerer/TileMap
@onready var top_bound := $LevelBoundries/Top
@onready var bottom_bound := $LevelBoundries/Bottom
@onready var left_bound := $LevelBoundries/Left
@onready var right_bound := $LevelBoundries/Right

var rng := RandomNumberGenerator.new()


func _ready():
	Global.gameboard = self
	await get_tree().process_frame # Wait one frame for size to settle
	set_bounds()
#	for i in 100:
#		print(get_spawn_group_position(Vector2i(0,0), 100, 5))
#	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(64, 64))


# Moves the level barriers to be flush with gameboard size
func set_bounds():
	top_bound.position = Vector2i.ZERO
	bottom_bound.position = size
	left_bound.position = Vector2i.ZERO
	right_bound.position = size


# Returns a random point along the left and right sides of the gameboard
func get_spawnable_position() -> Vector2i:
	var output = Vector2i(rng.randi_range(-1,1) * size.x, rng.randi_range(0, size.y))
	return output


# Returns a point above or below the central_pt
func get_spawn_group_position(central_pt:Vector2i, max_offset:int=0, step:int=1) -> Vector2i:
	var rand_offset := 0
	while rand_offset == 0:
		rand_offset = snappedi(rng.randi_range(-max_offset, max_offset), step)
	return central_pt + Vector2i(0, rand_offset)


func set_enemy(enemy):
	pass


func hi():
	print("HI")
