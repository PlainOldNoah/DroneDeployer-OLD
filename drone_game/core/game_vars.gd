extends Node

# Mod = multiplier, bonus = addition

var default_vars:Dictionary = {
	# Hub
	"starting_drone_count":3,
	"starting_health":3,
	"drone_launch_cooldown":0.5,
	
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
