tool
extends MarginContainer

signal pressed()

export(Texture) var icon setget set_icon
export var desc:String = "<SET TEXT>" setget set_label_text


func set_icon(new_icon):
	icon = new_icon
	$VBoxContainer/Control/TextureButton/TextureRect.texture = new_icon


func set_label_text(new_text):
	desc = new_text
	$VBoxContainer/Label.text = new_text


func _on_TextureButton_pressed():
	emit_signal("pressed")
