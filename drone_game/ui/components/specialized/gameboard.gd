extends Control

@onready var centerer := $MarginContainer/Centerer
@onready var mid_pt := $MarginContainer/Centerer/MidPoint
@onready var current_map := $MarginContainer/Centerer/TileMap
@onready var level_objects := $LevelObjects
@onready var hub:Hub = $MarginContainer/Centerer/Hub
@onready var gameboard_area := $MarginContainer/Centerer/GameboardArea/CollisionShape2D

@onready var top_bound := $LevelBoundries/Top
@onready var bottom_bound := $LevelBoundries/Bottom
@onready var left_bound := $LevelBoundries/Left
@onready var right_bound := $LevelBoundries/Right

var dist_outside_screen:int = 150
var lr_to_tb_ratio:int = 3 #Ratio of LR spawns to TB spawns
var rng := RandomNumberGenerator.new()


func _ready():
	Global.gameboard = self
	await get_tree().process_frame # Wait one frame for size to settle
	set_positions()


# Moves the level barriers to be flush with gameboard size
func set_positions():
	gameboard_area.shape.size = centerer.size
	
	top_bound.position = centerer.position
	bottom_bound.position = centerer.size + centerer.position
	left_bound.position = centerer.position
	right_bound.position = centerer.size + centerer.position
	
	current_map.global_position = mid_pt.global_position
	gameboard_area.global_position = mid_pt.global_position
	hub.global_position = mid_pt.global_position


# Returns a random point along the left and right sides of the gameboard
func get_spawnable_position() -> Vector2i:
	var output = Vector2.ZERO
	if rng.randi() % lr_to_tb_ratio == 0: # Top and Bottom
		output.x = rng.randi_range(0, size.x)
		@warning_ignore("incompatible_ternary")
		output.y = -dist_outside_screen if (rng.randi() % 2 == 0) else (size.y + dist_outside_screen)
	else: # Left and Right
		@warning_ignore("incompatible_ternary")
		output.x = -dist_outside_screen if rng.randi() % 2 == 0 else (size.x + dist_outside_screen)
		output.y = rng.randi_range(0, size.y)
	return output


# Returns a point above or below the central_pt
func get_spawn_group_position(central_pt:Vector2i, max_offset:int=0, step:int=1) -> Vector2i:
	var rand_offset := 0
	while rand_offset == 0:
		rand_offset = snappedi(rng.randi_range(-max_offset, max_offset), step)
	return central_pt + Vector2i(0, rand_offset)


# Adds a child node to level_objects instead of gameboard itself
func add_object(object:Node):
#	level_objects.call_deferred("add_child", object)
	level_objects.add_child(object)


func set_enemy(enemy_path:String, enemy_type:String, count:int):
	var enemy_scene := load(enemy_path)
	for i in count:
		var enemy_inst = enemy_scene.instantiate()
		enemy_inst.set_position(get_spawn_group_position(get_spawnable_position(), 10))
		enemy_inst.load_data(enemy_type)
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
