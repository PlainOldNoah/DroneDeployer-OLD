extends Node

const tile_size:int = 32

# MAIN SCENES REFERENCE
var game_manager:GameManager = null
var gui:GUI = null
var gameboard:Control = null
var hub_scene:Hub = null
var engr_menu:Control = null
var fabricator:Control = null

#var default_game_vars:Dictionary = {
#	"max_drones":0,
#	"max_health":3,
#	"curr_health":0,
#	"curr_scrap":0,
#	"spent_scrap":0,
#	"score":0,
#	"curr_survived_sec":0,
#}
#
#var game_vars:Dictionary = {}

var debug:Dictionary = {
	"USE_SCRAP":true,
	"GOD_MODE":false,
}

const GROUP_LIST:Array = [
	"ENEMY","PLAYER",
	"HUB","DRONE","SLUG",
	"EXP", "DEBRIS",
	"POPUP"
	]

func add_to_groups(caller:Node, groups:Array):
	for group in groups:
		if GROUP_LIST.has(group):
			caller.add_to_group(group)
		else:
			print_debug("ERROR: <", group, "> DOES NOT EXIST")


# Unused modifier for global stats
#var global_modifiers:Dictionary = {
#	"starting_drone_count":3,
#	"starting_health":3,
#	"drone_launch_cooldown":0.5,
#	"drone_skip_cooldown":0.25,
#
#	# Lifeforms
#	"global_speed_modifier":1,
#	"global_drone_speed_mod":1,
#	"global_enemy_speed_mod":1,
#
#	"global_drone_crit_chance_mod":1,
#	"global_drone_crit_chance_bonus":0,
#	"global_enemy_crit_chance_mod":1,
#	"global_enemy_crit_chance_bonus":0,
#
#	"global_drone_health_mod":1,
#	"global_drone_health_bonus":0,
#	"global_enemy_health_mod":1,
#	"global_enemy_health_bonus":0,
#
#	"global_drone_pickup_rng_mod":1,
#	"global_drone_pickup_rng_bonus":0,
#}
