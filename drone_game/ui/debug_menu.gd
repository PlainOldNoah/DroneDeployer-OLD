class_name DebugMenu
extends Control


func _ready():
	yield(get_tree().root, "ready")


# Toggles a var in Hub.gd that stops damage from being reported
func _on_ToggleInvincible_toggled(button_pressed):
	print("DEBUG| Invinciblity: ", button_pressed)
	Global.hub_scene.debug_invincible = button_pressed


# Tells the level manager to spawn a slug enemy
func _on_SpawnSlug_pressed():
	Global.level_manager.spawn_enemy()


# Creates an enhancement
func _on_CreateEnhancement_pressed():
	Global.mod_manager.create_enhancement("bounce", 1)
	print("DEBUG| Enhancement Created")
#	print("DEBUG| Enhancement Created [", Global.mod_manager.free_enhancements.size(), "]")
