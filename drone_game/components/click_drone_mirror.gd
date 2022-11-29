extends "res://components/base_drone_mirror.gd"

signal relay_btn_pressed()

onready var btn:Button = $Button

var enabled:bool = true


func _ready():
	enable()


# Grays out the drone and turns off clickability
func disable():
	enabled = false
	modulate.a = 0.2
#	mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


# Returns alpha to normal and allows cursor input
func enable():
	enabled = true
	modulate.a = 1
#	mouse_filter = Control.MOUSE_FILTER_STOP
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_Button_pressed():
	if enabled:
		emit_signal("relay_btn_pressed", self)
