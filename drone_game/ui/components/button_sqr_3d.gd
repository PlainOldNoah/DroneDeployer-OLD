@tool
extends AspectRatioContainer

signal pressed()

@export var icon:Texture = null : set = set_icon
@onready var animation_player := $AnimationPlayer

var mouse_hovering:bool = false


#func _ready():
#	animation_player.play("RESET")


func set_icon(new_icon):
	icon = new_icon
	$ButtonBase/MarginContainer/TextureRect.texture = new_icon


# Dynamically sets the animation keys to move the icon
func set_icon_move_keys():
	await get_tree().process_frame
	
	# TODO: Fix this bullshit
	
#	print("1: ", $ButtonBase/TextureRect.size, ", ", $ButtonBase/TextureRect.position)
	var upper_pt:Vector2 = $ButtonBase/TextureRect.position
	var lower_pt:Vector2 = upper_pt * Vector2(1, 2)
	
	var unique_anim_lib:AnimationLibrary = AnimationLibrary.new()
	animation_player.add_animation_library("Unique", unique_anim_lib)
	for i in animation_player.get_animation_list():
		var origin:Animation = animation_player.get_animation(i)
		var dupe = origin.duplicate()
		unique_anim_lib.add_animation(i.trim_prefix("ButtonSquare3D/"), dupe)
	
	animation_player.remove_animation_library("ButtonSquare3D")

	print(animation_player.get_animation_list())

#	print("2: ", upper_pt, ", ", lower_pt)

#	var temp_anim :Animation = animation_player.get_animation("button_down")
#	temp_anim.track_set_key_value(1, 0, upper_pt)
#	temp_anim.track_set_key_value(1, 1, lower_pt)
#	temp_anim = animation_player.get_animation("button_up")
#	temp_anim.track_set_key_value(1, 0, lower_pt)
#	temp_anim.track_set_key_value(1, 1, upper_pt)
#	temp_anim = animation_player.get_animation("RESET")
#	temp_anim.track_set_key_value(1, 0, upper_pt)
	


# Play the button down and then up animation, then check for mouse hover
func play_animation():
	animation_player.play("Unique/button_down")
	emit_signal("pressed")
	animation_player.queue("Unique/button_up")
	await animation_player.animation_finished
	
	update_hover_texture()


# Show hovering texture if button is not being pressed and mouse hovering
func update_hover_texture():
	if mouse_hovering:
		animation_player.queue("Unique/hover")
	else:
		animation_player.queue("Unique/RESET")


func _on_click_region_pressed():
	print(self, " has been clicked")
	play_animation()


func _on_click_region_mouse_entered():
	mouse_hovering = true
	update_hover_texture()


func _on_click_region_mouse_exited():
	mouse_hovering = false
	update_hover_texture()


func _on_button_base_resized():
	set_icon_move_keys()
