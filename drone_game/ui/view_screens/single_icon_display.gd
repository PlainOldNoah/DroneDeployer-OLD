@tool
extends Control

@export var icon:Texture = null : set = set_icon

func set_icon(new_texture):
	icon = new_texture
	$ContentContainer/TextureRect.texture = new_texture
