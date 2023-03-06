extends MarginContainer

signal pressed()

func _on_TextureButton_pressed():
	emit_signal("pressed")


func _on_texture_button_button_down():
	$ButtonDownASP.play()


func _on_texture_button_button_up():
	if not $ButtonDownASP.playing:
		$ButtonUpASP.play()
