class_name DroneMirror
extends Control

signal relay_btn_pressed()

@onready var drone_icon:TextureRect = $DroneIcon
@onready var popup_window := $CanvasLayer/DroneStatsPopup
@onready var btn:Button = $Button

var drone_ref:Drone = null
var enabled:bool = false
var mouse_hovering:bool = false

var cursor_clickable := CURSOR_POINTING_HAND
var cursor_hover := CURSOR_HELP
var cursor_disabled := CURSOR_FORBIDDEN
var cursor_default := CURSOR_ARROW


func _ready():
	popup_window.visible = false
	Global.add_to_groups(self, ["POPUP"])


func init(_min_size:int=32, clickable:bool=false, hover_stats:bool=false):
#	set_rect_size(min_size) # Required to have mirror float to top of container
	
	if clickable: 
		enable()
	btn.disabled = !clickable
	
	if hover_stats:
		var _ok := connect("mouse_entered",Callable(self,"_on_DroneMirror_mouse_entered"))
		_ok = connect("mouse_exited",Callable(self,"_on_DroneMirror_mouse_exited"))


func _input(event):
	if event.is_action_pressed("ui_down"):
		print(get_parent().name, ", ", get_parent().size)


# Base Functions
# Links the drone to this node
func set_drone(drone:Drone):
	drone_ref = drone
	drone_icon.texture = drone.get_sprite()
	modulate = drone.modulate
	popup_window.display_new_drone(drone)


# Advanced set_drone that can enable or disable when called
func set_drone_with_state(drone:Drone):
	set_drone(drone)
	if drone_ref.state == drone.STATES.IDLE: # idle
		enable()
	else:
		disable()


# Clears all non-init data
func reset():
	drone_ref = null
	drone_icon.texture = null
	modulate = Color(1, 1, 1, 1)


# Note: Whatever the parent of this node it will need to update the rect size
# Sets the texturerect to a square area with length of factor
func set_rect_size(factor:int):
	custom_minimum_size = Vector2(factor, factor)
	size = custom_minimum_size


# Clicking Functions
# Returns alpha to normal and allows cursor input
func enable():
	enabled = true
	modulate.a = 1
	mouse_default_cursor_shape = cursor_clickable


# Grays out the drone and turns off clickability
func disable():
	enabled = false
	modulate.a = 0.2
	mouse_default_cursor_shape = cursor_disabled


func _on_Button_pressed():
	if enabled:
		emit_signal("relay_btn_pressed", self)


# Hover Functions
func _process(_delta):
	popup_window.global_position = get_global_mouse_position()# + Vector2(0, 8)
#	print(size)


# Enables or disables the popup window
func toggle_popup(state:bool):
	if state and not enabled:
		set_default_cursor_shape(cursor_hover)
	
	mouse_hovering = state
	popup_window.visible = state
	set_process(state)


func _on_DroneMirror_mouse_entered():
	toggle_popup(true)


func _on_DroneMirror_mouse_exited():
	toggle_popup(false)
