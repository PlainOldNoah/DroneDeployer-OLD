tool
extends Control

signal pressed()

export(Texture) var icon setget set_icon
export var desc:String = "<SET TEXT>" setget set_label_text
export(int, -100, 500, 1) var button_size = 0 setget resize_button
export(int, -100, 500, 1) var icon_size = 0 setget resize_icon


func set_icon(new_icon):
	icon = new_icon
	$"%IconRect".texture = new_icon


func set_label_text(new_text):
	desc = new_text
	$"%DescLabel".text = new_text


func resize_button(new_value):
	button_size = new_value
	var m = $"%ButtonSizer"
	m.add_constant_override("margin_bottom", new_value)
	m.add_constant_override("margin_left", new_value)
	m.add_constant_override("margin_right", new_value)
	m.add_constant_override("margin_top", new_value)


func resize_icon(new_value):
	icon_size = new_value
	var m = $"%IconSizer"
	m.add_constant_override("margin_bottom", new_value)
	m.add_constant_override("margin_left", new_value)
	m.add_constant_override("margin_right", new_value)
	m.add_constant_override("margin_top", new_value)


func _on_TextureButton_pressed():
	emit_signal("pressed")
