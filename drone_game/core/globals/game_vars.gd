extends Node

const DEFAULT_DRONE_STATS:Dictionary = {
	"display_name":"Drone", # Drones name in game
	"max_battery":100, # Maximum battery level
	"battery_drain":5, # How much battery is lost per second while active
	"speed":200, # How fast drone moves
	"damage":1, # Attack damage against enemies
	"crit_chance":0, # Percentage chance of dealing a critical hit
	"crit_dmg_mult":1, # Normal damage multiplier when dealing crit hit
	"bounce":100, # How many bounces drone can make before going home
	}

const DEFAULT_ENHANCEMENTS:Dictionary = {
	"max_battery": {
		"values": [10, 30, 50, 100],
	},
	"battery_drain": {
		"values": [-0.25, -0.5, -1, -2],
	},
	"speed": {
		"values": [25, 50, 100, 200],
	},
	"damage": {
		"values": [1, 2, 4, 8],
	},
	"crit_chance": {
		"values": [1, 5, 10, 50],
	},
	"crit_dmg_mult": {
		"values": [0.5, 1, 2, 3],
	},
	"bounce": {
		"values": [3, 8, 15, 30],
	},
	
#	"max_battery_1": {
#		"rarity":"common",
#		"value":10},
#	"max_battery_2": {
#		"rarity":"uncommon",
#		"value":30},
#	"max_battery_3": {
#		"rarity":"rare",
#		"value":50},
#	"max_battery_4": {
#		"rarity":"legendary",
#		"value":100},
	
#	"battery_drain_1": {
#		"rarity":"common",
#		"value":0.25},
#	"battery_drain_2": {
#		"rarity":"uncommon",
#		"value":0.5},
#	"battery_drain_3": {
#		"rarity":"rare",
#		"value":1},
#	"battery_drain_4": {
#		"rarity":"legendary",
#		"value":2},
#
#	"speed_1": {
#		"rarity":"common",
#		"value":25},
#	"speed_2": {
#		"rarity":"uncommon",
#		"value":50},
#	"speedn_3": {
#		"rarity":"rare",
#		"value":100},
#	"speed_4": {
#		"rarity":"legendary",
#		"value":200},
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
