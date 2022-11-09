extends Control

onready var camera:Camera2D = $ViewportContainer/Viewport/Camera2D
#onready var hub:Hub = $ViewportContainer/Viewport/LevelManager/Hub
onready var sub_viewport:Viewport = $ViewportContainer/Viewport


func _ready():
	var mid_pt:Vector2 = Vector2(sub_viewport.size.x / 2, sub_viewport.size.y / 2)
#	hub.position = mid_pt
	camera.offset = mid_pt


func _input(event): # DEBUGGING FUNCTION
	if event.is_action_pressed("ui_left"):
		camera.zoom -= Vector2(0.1, 0.1)
	elif event.is_action_pressed("ui_right"):
		camera.zoom += Vector2(0.1, 0.1)
