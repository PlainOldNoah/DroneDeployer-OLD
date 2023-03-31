extends Node

@onready var gui:CanvasLayer = $GameManager/GUI

func _ready():
	gui.request_menu(gui.MENUS.MAIN)
	randomize()
