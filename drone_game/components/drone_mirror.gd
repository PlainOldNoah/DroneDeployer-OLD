extends Control

signal relay_btn_pressed()

onready var texture_rect:TextureRect = $TextureRect
onready var popup_window := $CanvasLayer/UIPanel
onready var btn:Button = $Button

var drone_ref:Drone = null
var enabled:bool = false
var mouse_hovering:bool = false

var cursor_clickable := CURSOR_POINTING_HAND
var cursor_hover := CURSOR_HELP
var cursor_disabled := CURSOR_FORBIDDEN
var cursor_default := CURSOR_ARROW


#func _ready():
#	init(128, false, false)


func init(size:int=32, clickable:bool=false, hover_stats:bool=false):
	set_rect_size(size)
	
	if clickable: 
		enable()
	btn.disabled = !clickable
	
	if hover_stats:
		var _ok := connect("mouse_entered", self, "_on_DroneMirror_mouse_entered")
		_ok = connect("mouse_exited", self, "_on_DroneMirror_mouse_exited")
	popup_window.visible = hover_stats


# Base Functions
# Links the drone to this node
func set_drone(drone:Drone):
	drone_ref = drone
	texture_rect.texture = drone.get_sprite()
	modulate = drone.modulate


# Clears all non-init data
func reset():
	drone_ref = null
	texture_rect.texture = null
	modulate = Color(1, 1, 1, 1)


# Note: Whatever the parent of this node it will need to update the rect size
# Sets the texturerect to a square area with length of factor
func set_rect_size(factor:int):
	rect_min_size = Vector2(factor, factor)
	rect_size = rect_min_size


# Clicking Functions
# Returns alpha to normal and allows cursor input
func enable():
	enabled = true
	modulate.a = 1
#	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = cursor_clickable


# Grays out the drone and turns off clickability
func disable():
	enabled = false
	modulate.a = 0.2
#	mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_default_cursor_shape = cursor_disabled


func _on_Button_pressed():
	if enabled:
		emit_signal("relay_btn_pressed", self)


# Hover Functions
func _process(_delta):
	popup_window.rect_global_position = get_global_mouse_position()# + Vector2(0, 8)


# Enables or disables the popup window
func toggle_popup(state:bool):
	if state and not enabled:
		mouse_default_cursor_shape = cursor_hover
	
	mouse_hovering = state
	popup_window.visible = state
	set_process(state)


func _on_DroneMirror_mouse_entered():
	toggle_popup(true)


func _on_DroneMirror_mouse_exited():
	toggle_popup(false)
