extends Control

onready var drone_display:GridContainer = $MarginContainer/HBoxContainer/UIPanel/MarginContainer/DroneDisplay


func _ready():
	var _ok = null # Connect to game manager to fill drone display with drones
	_ok = null # Connect to fabricator(?) to get crafted upgrades & enhancements


func update_drone_display():
	pass


# Show the stats of the drone currently in the workbench
func update_drone_stats():
	pass


# Populate the equipped mods box with the selected drones equipped mods
func update_equipped_mods():
	pass


