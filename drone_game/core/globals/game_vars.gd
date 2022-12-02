extends Node

const DEFAULT_DRONE_STATS:Dictionary = {
	"display_name":"Drone", # Drones name in game
	"max_battery":100, # Maximum battery level
	"battery_drain":5, # How much battery is lost per second while active
	"speed":200, # How fast drone moves
	"damage":1, # Attack damage against enemies
	"crit_chance":0, # Percentage chance of dealing a critical hit
	"crit_dmg_mult":1, # Normal damage multiplier when dealing crit hit
	"bounce":1, # How many bounces drone can make before going home
	}

# Mod = multiplier, bonus = addition
var initial:Dictionary = {
	# Hub
	"starting_drone_count":3,
	"starting_health":3,
	"drone_launch_cooldown":0.5,
	"drone_skip_cooldown":0.25,
	
	# Lifeforms
	"global_speed_modifier":1,
	"global_drone_speed_mod":1,
	"global_enemy_speed_mod":1,
	
	"global_drone_crit_chance_mod":1,
	"global_drone_crit_chance_bonus":0,
	"global_enemy_crit_chance_mod":1,
	"global_enemy_crit_chance_bonus":0,
	
	"global_drone_health_mod":1,
	"global_drone_health_bonus":0,
	"global_enemy_health_mod":1,
	"global_enemy_health_bonus":0,
	
	"global_drone_pickup_rng_mod":1,
	"global_drone_pickup_rng_bonus":0,
}

#var runtime:Dictionary = {}
#
#func reset():
#	runtime = initial
