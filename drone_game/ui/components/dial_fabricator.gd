extends "res://ui/components/dial.gd"

signal dial_selection_changed

@export var mouse_active_zone:NodePath = ""

var mouse_down:bool = false
var mouse_hover:bool = false
var rads:float = 0
var selected_pos:int = 0


func _ready():
	super._ready()
	get_node(mouse_active_zone).connect("mouse_entered", verify_mouse_hover)
	get_node(mouse_active_zone).connect("mouse_exited", verify_mouse_hover)
	toggle_active(owner.visible)


func _input(event):
	if event.is_action_pressed("left_mouse"):
		mouse_down = true
	elif event.is_action_released("left_mouse"):
		mouse_down = false


# Setter for selected_pos
func set_selected_pos(value:int):
	if selected_pos != value:
		selected_pos = value
		emit_signal("dial_selection_changed")


# Checks if mouse is within the mouse_active_zone
# Code referenced from mouse_exited signal tooltip
func verify_mouse_hover():
	if Rect2(Vector2(),get_node(mouse_active_zone).size).has_point(get_node(mouse_active_zone).get_local_mouse_position()):
		mouse_hover = true
	else:
		mouse_hover = false


# OVERRIDE
func follow_mouse_smooth():
	if mouse_down and mouse_hover:
		rads = (get_global_mouse_position() - cursor_eye.global_position).angle() + (PI/2)
	rads = clampf(snapped(rads, deg_to_rad(60)), 0.0, PI)
	spinner.rotation_degrees = rad_to_deg(lerp_angle(deg_to_rad(spinner.rotation_degrees), rads, rotation_weight))
	
	# NOTE: This statment waits until the dial settles in place
	if (roundi(spinner.rotation_degrees) % 60) == 0:
		set_selected_pos((3 * rads) / PI)


# Turns on or off the dial depending on need
func toggle_active(state:bool):
	set_process(state)
	set_process_input(state)


# Turns off process and input when not seen/in use
func _on_visibility_changed():
	toggle_active(owner.visible)
