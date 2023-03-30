extends Control

@onready var current_map := $Centerer/TileMap
@onready var top_bound := $LevelBoundries/Top
@onready var bottom_bound := $LevelBoundries/Bottom
@onready var left_bound := $LevelBoundries/Left
@onready var right_bound := $LevelBoundries/Right


func _ready():
	await get_tree().process_frame # Wait one frame for size to settle
	set_bounds()
#	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(64, 64))


# Moves the level barriers to be flush with gameboard size
func set_bounds():
	top_bound.position = Vector2i.ZERO
	bottom_bound.position = size
	left_bound.position = Vector2i.ZERO
	right_bound.position = size
