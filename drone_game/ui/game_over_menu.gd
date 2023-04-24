extends Control


func _on_retry_btn_pressed():
	Global.gui.dismiss_menu()
	Global.game_manager.start_game()


func _on_main_menu_btn_pressed():
	Global.gui.request_menu(Global.gui.MENUS.MAIN)
