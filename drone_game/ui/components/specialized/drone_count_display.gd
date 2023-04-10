@tool
extends Control

@export_range(1, 128) var font_size:int = 24 : set = set_font_size

@onready var main_label := $Panel/Label


# Takes in seconds and runs formatting calculations
func update_count(curr:int, total:int):
	main_label.text = "%02d-%02d" % [curr, total]


func set_font_size(value:int):
	font_size = value
	$Panel/Label.add_theme_font_size_override("font_size", value)
	$Panel/Label/BgLabel.add_theme_font_size_override("font_size", value)
