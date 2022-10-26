class_name LaunchQueueItem
extends TextureRect

#signal movement_changed()

var moving:bool = false
var target_position:Vector2 = rect_position


func set_moving(value:bool):
	moving = value
#	emit_signal("movement_changed", value)
