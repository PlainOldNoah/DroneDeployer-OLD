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
	EnemyManager.spawn_slugs(1, 1)


# Creates an enhancement
func _on_CreateEnhancement_pressed():
	ModManager.create_enhancement("max_battery", 50)
