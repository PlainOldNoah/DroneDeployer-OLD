extends Control

@onready var current_map := $Centerer/TileMap
@onready var level_objects := $LevelObjects
@onready var hub:Hub = $Centerer/Hub

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


# Adds a child node to level_objects instead of gameboard itself
func add_object(object:Node):
	level_objects.add_child(object)


func set_enemy(enemy_path:String, count:int, health:int, speed:int, damage:int):
	var enemy_scene := load(enemy_path)
	for i in count:
		var enemy_inst = enemy_scene.instantiate()
		enemy_inst.set_position(get_spawn_group_position(get_spawnable_position(), 10))
		enemy_inst.set_stats(health, speed, damage)
		add_object(enemy_inst)


func _on_mouse_entered():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_mouse_exited():
	mouse_default_cursor_shape = Control.CURSOR_ARROW


# Calls down to the HUB to deploy or skip drones based on input
func _on_gui_input(event):
	if event.is_action_pressed("deploy") and hub.can_deploy:
		hub.deploy_drone()
	elif event.is_action_pressed("deploy_skip") and hub.can_skip:
		hub.skip_drone()
