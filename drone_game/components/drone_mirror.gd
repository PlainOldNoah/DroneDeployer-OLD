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


#func _on_DroneMirror_gui_input(event):
#	print(event)
