@tool
extends AspectRatioContainer

signal pressed()

@export var icon:Texture = null : set = set_icon
@onready var animation_player := $AnimationPlayer

var mouse_hovering:bool = false


func _ready():
	animation_player.play("SqrBtn3D/RESET")


func set_icon(new_icon):
	icon = new_icon
	$ButtonBase/IconTextureRect.texture = new_icon


# Play the button down and then up animation, then check for mouse hover
func play_animation():
	animation_player.play("SqrBtn3D/button_down")
	emit_signal("pressed")
	animation_player.queue("SqrBtn3D/button_up")
	await animation_player.animation_finished
	
	update_hover_texture()


# Show hovering texture if button is not being pressed and mouse hovering
func update_hover_texture():
	if mouse_hovering:
		animation_player.queue("SqrBtn3D/hover")
	else:
		animation_player.queue("SqrBtn3D/RESET")


func _on_click_region_pressed():
	play_animation()


func _on_click_region_mouse_entered():
	mouse_hovering = true
	update_hover_texture()


func _on_click_region_mouse_exited():
	mouse_hovering = false
	update_hover_texture()
