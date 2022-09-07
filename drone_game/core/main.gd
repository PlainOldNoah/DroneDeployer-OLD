extends Node

func _ready():
	OS.set_window_position(
		OS.get_screen_position(OS.get_current_screen()) + 
		OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	
	set_necessary_visible()


func set_necessary_visible():
	$GameManager/GUI.show()
