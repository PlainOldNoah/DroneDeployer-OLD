extends MarginContainer

signal pressed()

func _on_TextureButton_pressed():
	emit_signal("pressed")
