extends Node

func _ready():
	OS.center_window()
	
	set_necessary_visible()
	
	randomize()


func set_necessary_visible():
	$GameManager/GUI.show()
