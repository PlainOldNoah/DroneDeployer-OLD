@tool
extends "res://ui/components/button_base_3d.gd"

@export var icon:Texture = null : set = set_icon

func set_icon(new_icon):
	icon = new_icon
	$ButtonBase/IconTextureRect.texture = new_icon
