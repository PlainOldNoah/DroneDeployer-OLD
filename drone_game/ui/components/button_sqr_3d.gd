extends Control


@onready var test := $ButtonBase/TextureRect
@onready var animation_player := $AnimationPlayer


func _ready():
	animation_player.play("RESET")


func play_animation():
	animation_player.play("button_press")
	await animation_player.animation_finished
	animation_player.play_backwards("button_press")


func _on_texture_button_pressed():
	play_animation()
