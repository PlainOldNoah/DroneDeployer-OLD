@tool
class_name SevenSegmentDisplay
extends Control

@export_range(1, 12) var digits:int = 1 : set = set_digits
@export_range(1, 128) var font_size:int = 24 : set = set_font_size

@onready var foreground_label := $Panel/BackgroundLabel/ForegroundLabel


func _ready():
	set_value(0)


# Prepares the labels to hold value number of chars
func set_digits(value:int):
	digits = value
	$Panel/BackgroundLabel.text = ""
	$Panel/BackgroundLabel/ForegroundLabel.text = ""
	for i in value:
		$Panel/BackgroundLabel.text += "8"
		$Panel/BackgroundLabel/ForegroundLabel.text += "0"

func set_font_size(value:int):
	font_size = value
	$Panel/BackgroundLabel.add_theme_font_size_override("font_size", value)
	$Panel/BackgroundLabel/ForegroundLabel.add_theme_font_size_override("font_size", value)


# Sets the main value
func set_value(value:int):
	value = clamp(value, 0, (pow(10, digits) - 1))
	foreground_label.text = "%0*d" % [digits, value]
