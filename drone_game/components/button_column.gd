extends Control

signal btn_pressed()

func _on_CircleButton_pressed(extra_arg_0):
	emit_signal("btn_pressed", extra_arg_0)
