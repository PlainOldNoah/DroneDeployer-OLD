extends Control

@onready var start_btn := $MarginContainer/VBoxContainer/LRDivide/LeftSegment/ButtonControlOutline/ButtonControlMargin/HBoxContainer/VBoxContainer/StartBtn

func _on_start_btn_pressed():
	Global.gui.dismiss_menu()
	Global.game_manager.start_game()


func _on_quit_btn_pressed():
	get_tree().quit()
