extends Control


func _on_StartBtn_pressed():
	Global.gui.dismiss_menu()
	Global.game_manager.start_game()
