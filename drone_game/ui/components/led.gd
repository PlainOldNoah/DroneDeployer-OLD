extends Control

const RED:Color = Color.RED
const GREEN:Color = Color.GREEN
const YELLOW:Color = Color.YELLOW
const OFF:Color = Color.DIM_GRAY

@onready var led_light:TextureRect = $Light


# Changes the LED light to new_color
func set_light_color(new_color:Color):
	led_light.self_modulate = new_color
