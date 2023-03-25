extends "res://ui/components/dial.gd"

@export var mouse_active_zone:NodePath = ""

var follow_mouse:bool = false
var rads:float = 0

func _ready():
	super._ready()
	get_node(mouse_active_zone).connect("mouse_entered", verify_mouse_hover)
	get_node(mouse_active_zone).connect("mouse_exited", verify_mouse_hover)


func _input(event):
	if event.is_action_pressed("left_mouse"):
		print("pressed")
	elif event.is_action_released("left_mouse"):
		print("release")


# Override
func follow_mouse_smooth():
	if follow_mouse:
		rads = (get_global_mouse_position() - cursor_eye.global_position).angle() + (PI/2)
	rads = clampf(snapped(rads, deg_to_rad(60)), 0.0, PI)
	spinner.rotation_degrees = rad_to_deg(lerp_angle(deg_to_rad(spinner.rotation_degrees), rads, rotation_weight))
	
	
#	if (roundi(spinner.rotation_degrees) % 60) == 0: # Checks if snapped into place
#		print((roundi(spinner.rotation_degrees) / 60) + 1) # Returns what core is faced
#	else:
#		print("MOVING")


func verify_mouse_hover():
	if not Rect2(Vector2(),get_node(mouse_active_zone).size).has_point(get_node(mouse_active_zone).get_local_mouse_position()):
		follow_mouse = false
#		set_process_input(false)
	else:
		follow_mouse = true


# HOVERING + MOUSE DOWN = MOVE DIAL
