extends Panel

@onready var indicator_pivot := $IndicatorPivot
@export var rotate_weight:float = 0.025

var target:float = 0


func _ready():
	indicator_pivot.rotation_degrees = 60


func set_pivot(curr_value:float, max_value:float):
	var percentage:float = curr_value / max_value
	target = deg_to_rad((120 * percentage) - 60)


func _process(_delta):
	indicator_pivot.rotation = lerp_angle(indicator_pivot.rotation, (target), rotate_weight)
