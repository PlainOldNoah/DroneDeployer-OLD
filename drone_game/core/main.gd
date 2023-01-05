extends Node

onready var gui:CanvasLayer = $GameManager/GUI

func _ready():
	OS.center_window()
	gui.request_menu(gui.MENUS.MAIN)
	randomize()
