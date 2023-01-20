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
	Global.level_manager.spawn_enemy("res://lifeforms/slug.tscn")


# Creates an enhancement
func _on_CreateEnhancement_pressed():
#	var test:Dictionary = {}
#	for i in 500000:
#		var new_element = Global.mod_manager.generate_enhancement()
#		if test.has(new_element):
#			test[new_element] += 1
#		else:
#			test[new_element] = 0
#	print(test)
	
	Global.mod_manager.create_enhancement("max_battery", 50)
	Global.mod_manager.create_enhancement("battery_drain", 50)
	Global.mod_manager.create_enhancement("speed", 100)
	Global.mod_manager.create_enhancement("damage", 5)
	Global.mod_manager.create_enhancement("crit_chance", 50)
	Global.mod_manager.create_enhancement("crit_dmg_mult", 50)
	Global.mod_manager.create_enhancement("bounces", 3)
	
#	Global.mod_manager.generate_rand_enhancement()
	
#	Global.mod_manager.create_enhancement("bounce", 1)
#	print("DEBUG| Enhancement Created")
#	print("DEBUG| Enhancement Created [", Global.mod_manager.free_enhancements.size(), "]")
