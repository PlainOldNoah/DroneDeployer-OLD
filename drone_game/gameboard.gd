extends Node2D

onready var hub:Hub = $Hub
onready var tilemap:TileMap = $TileMap
onready var camera:Camera2D = $Camera2D

onready var barrier_top:CollisionShape2D = $ScreenEdgeBarrier/BarrierTop
onready var barrier_bottom:CollisionShape2D = $ScreenEdgeBarrier/BarrierBottom
onready var barrier_left:CollisionShape2D = $ScreenEdgeBarrier/BarrierLeft
onready var barrier_right:CollisionShape2D = $ScreenEdgeBarrier/BarrierRight

func _ready():
	var view_rect:Rect2 = get_viewport_rect()
	
	self.global_position = view_rect.get_center()
	
	fill_cells(view_rect)


func move_barriers(area:Rect2):
	var height:int = (area.size.y * camera.zoom.y) / 2 # Top to bottom
	var width:int = (area.size.x * camera.zoom.x) / 2 # Left to Right
	
	print(height, ", ", width)
	
	height *= 0.95
	width *= 0.95

	
	barrier_top.shape.extents = Vector2(width, 10)
	barrier_top.position = Vector2(0, -height)
	
	barrier_bottom.shape.extents = Vector2(width, 10)
	barrier_bottom.position = Vector2(0, height)

	barrier_left.shape.extents = Vector2(10, height)
	barrier_left.position = Vector2(-width, 0)
#
	barrier_right.shape.extents = Vector2(10, height)
	barrier_right.position = Vector2(width, 0)
#

func fill_cells(area:Rect2):
	var num_tiles_x:int = ceil(area.end.x / 32.0)
	var num_tiles_y:int = ceil(area.end.y / 32.0)
	
	num_tiles_x = num_tiles_x + 1 if num_tiles_x % 2 == 1 else num_tiles_x
	num_tiles_y = num_tiles_y + 1 if num_tiles_y % 2 == 1 else num_tiles_y
	
	print(num_tiles_x, ", ", num_tiles_y)
	
	for i in num_tiles_x:
		for j in num_tiles_y:
			tilemap.set_cell(i - num_tiles_x / 2, j - num_tiles_y / 2, 1)


func _input(event): # DEBUGGING FUNCTION
	if event.is_action_pressed("ui_right"):
		camera.zoom -= Vector2(0.1, 0.1)
	elif event.is_action_pressed("ui_left"):
		camera.zoom += Vector2(0.1, 0.1)
	
	move_barriers(get_viewport().get_visible_rect())
