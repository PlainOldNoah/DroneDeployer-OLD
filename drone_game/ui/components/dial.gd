extends Control

@export var rotation_weight:float = 0.2

@onready var spinner := $Spinner
@onready var cursor_eye := $CursorEye


func _ready():
	var _ok = self.resized.connect(_on_resized)


func _process(_delta):
	follow_mouse_smooth()


func set_center_point():
	await get_tree().process_frame # Things get stupid without this
	var spinner_center:Vector2 = spinner.size * Vector2(0.5, 0.4051724)
	spinner.pivot_offset = spinner_center
	cursor_eye.position = spinner_center


# Involves several rad-degree conversions
func follow_mouse_smooth():
	var rads = (get_global_mouse_position() - cursor_eye.global_position).angle() + (PI/2)
	spinner.rotation_degrees = rad_to_deg(lerp_angle(deg_to_rad(spinner.rotation_degrees), rads, rotation_weight))


func _on_resized():
	set_center_point()
