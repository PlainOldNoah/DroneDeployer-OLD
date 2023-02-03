extends Control


func _on_ResumeBtn_pressed():
	Global.gui.dismiss_menu()


func _on_RestartBtn_pressed():
	Global.gui.dismiss_menu()
	Global.game_manager.start_game()


func _on_QuitBtn_pressed():
	Global.gui.request_menu(Global.gui.MENUS.MAIN)
