class_name DebugMenu
extends Control


func _ready():
	await get_tree().root.ready


# Toggles a var in Hub.gd that stops damage from being reported
func _on_ToggleInvincible_toggled(button_pressed):
	print("DEBUG| Invinciblity: ", button_pressed)
	Global.hub_scene.debug_invincible = button_pressed


# Tells the level manager to spawn a slug enemy
func _on_SpawnSlug_pressed():
	Global.enemy_manager.spawn_slugs(1, 1)


# Creates an enhancement
func _on_CreateEnhancement_pressed():
	Global.mod_manager.create_enhancement("max_battery", 50)
#	Global.mod_manager.create_enhancement("battery_drain", 50)
#	Global.mod_manager.create_enhancement("speed", 100)
#	Global.mod_manager.create_enhancement("damage", 5)
#	Global.mod_manager.create_enhancement("crit_chance", 50)
#	Global.mod_manager.create_enhancement("crit_dmg_mult", 50)
#	Global.mod_manager.create_enhancement("bounces", 3)
