class_name DroneMirror
extends TextureRect

# Note: Whatever the parent of this node it will need to update the rect size

var drone_ref:Drone = null


func init(drone:Drone):
	drone_ref = drone
	texture = drone.get_sprite()
	modulate = drone.modulate


# Sets the texturerect to a square area with length of factor
func set_rect_size(factor:int):
	rect_min_size = Vector2(factor, factor)
	rect_size = rect_min_size


# Grays out the drone and turns off clickability
func disable():
	modulate.a = 0.2
#	mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


# Returns alpha to normal and allows cursor input
func enable():
	modulate.a = 1
#	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_DroneMirror_gui_input(event):
	if event is InputEventMouseButton:
		print("Clicked")
