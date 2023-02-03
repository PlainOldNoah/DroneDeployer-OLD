tool
class_name IconButton
extends MarginContainer

signal pressed()

onready var button_down_asp := $ButtonDownASP
onready var button_up_asp := $ButtonUpASP

export(Texture) var icon setget set_icon
export var desc:String = "" setget set_label_text


func set_icon(new_icon):
	icon = new_icon
	$VBoxContainer/Control/TextureRect.texture = new_icon

func set_label_text(new_text):
	desc = new_text
	$VBoxContainer/Label.text = new_text


func _on_TextureButton_pressed():
	emit_signal("pressed")

func _on_TextureButton_button_down():
	button_down_asp.play()

func _on_TextureButton_button_up():
	if not button_down_asp.playing:
		button_up_asp.play()
