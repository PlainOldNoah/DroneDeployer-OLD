extends Node

func _ready():
	OS.center_window()
	
	set_necessary_visible()


func set_necessary_visible():
	$GameManager/GUI.show()
