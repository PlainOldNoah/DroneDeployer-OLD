@tool
extends Control

@export_range(1, 128) var font_size:int = 24 : set = set_font_size

@onready var main_label := $Panel/Label


# Takes in seconds and runs formatting calculations
func update_time(seconds):
	var hours:int = 0
	
	var mins:int = floori(seconds / 60)
	seconds -= mins * 60
	
	if mins >= 60:
		hours = floori(mins / 60)
		mins -= hours * 60
		hours = clampi(hours, 0, 99)
	
	main_label.text = "%02d:%02d:%02d" % [hours, mins, seconds]


# Takes in the current and total drones to set the label
func update_drone_count(curr:int, total:int):
	main_label.text = "%03d-%03d" % [curr, total]


func set_font_size(value:int):
	font_size = value
	$Panel/Label.add_theme_font_size_override("font_size", value)
	$Panel/Label/BgLabel.add_theme_font_size_override("font_size", value)
