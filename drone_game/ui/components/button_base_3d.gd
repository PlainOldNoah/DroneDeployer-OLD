@tool
extends AspectRatioContainer

signal pressed()

@export var icon:Texture = null : set = set_icon
@export var wait_for_btn_up:bool = false # Emits the pressed signal after button goes back up

@onready var animation_player := $AnimationPlayer
@onready var button_press_sound := $BtnPressSound

var mouse_hovering:bool = false
var available:bool = true

func _ready():
	animation_player.play("RESET")


func set_icon(new_icon):
	icon = new_icon
	$ButtonBase/IconTextureRect.texture = new_icon


# Play the button down and then up animation, then check for mouse hover
func play_animation():
	animation_player.play("button_down")
	button_press_sound.play()
	
	if wait_for_btn_up:
		animation_player.queue("button_up")
		await animation_player.animation_finished
		emit_signal("pressed")
	else:
		emit_signal("pressed")
		animation_player.queue("button_up")
		await animation_player.animation_finished
		
	update_hover_texture()


# Show hovering texture if button is not being pressed and mouse hovering
func update_hover_texture():
	if mouse_hovering:
		animation_player.queue("button_hover")
	else:
		animation_player.queue("RESET")


# Controller for it button is ready or not
func toggle_ready(state:bool):
	available = state


func _on_click_mask_pressed():
	if available:
		play_animation()


func _on_click_mask_mouse_entered():
	mouse_hovering = true
	update_hover_texture()


func _on_click_mask_mouse_exited():
	mouse_hovering = false
	update_hover_texture()
