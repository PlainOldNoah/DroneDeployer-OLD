extends Control



func _on_RetryBtn_pressed():
	Global.gui.dismiss_menu()
	Global.game_manager.start_game()


func _on_MainMenuBtn_pressed():
	Global.gui.request_menu(Global.gui.MENUS.MAIN)
