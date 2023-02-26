extends Control

signal relay_btn_pressed()

func _on_Button_pressed():
	emit_signal("relay_btn_pressed", self)
