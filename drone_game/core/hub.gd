class_name Hub
extends StaticBody2D

onready var arrow_indicator:Position2D = $IndicatorPoint

func _process(delta):
	arrow_indicator.look_at(get_global_mouse_position())
