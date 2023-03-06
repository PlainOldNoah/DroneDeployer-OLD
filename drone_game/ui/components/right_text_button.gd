@tool
extends Control

signal pressed()

@export var label_text:String = "" : set = set_label_text
@export var label_font_size:int = 48 : set = set_label_font_size


func set_label_text(new_text:String):
	label_text = new_text
	$HBoxContainer/Label.text = new_text


# For use in editor, actual game requires setting in Theme
func set_label_font_size(new_size:int):
	label_font_size = new_size
	$HBoxContainer/Label.add_theme_font_size_override("font_size", new_size)


func _on_circle_button_pressed():
	emit_signal("pressed")
