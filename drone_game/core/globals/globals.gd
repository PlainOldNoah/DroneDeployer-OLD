extends Node

var tile_size:int = 32

var game_manager:GameManager = null
var drone_manager:DroneManager = null
var mod_manager:Node = null
var level_manager:LevelManager = null
var hub_scene:Hub = null

var gui:GUI = null
var stats_bar:MarginContainer = null
var launch_queue:Control = null
var engr_menu:Control = null
var fabricator:Control = null


const GROUP_LIST:Array = [
	"ENEMY","PLAYER",
	"HUB","DRONE","SLUG",
	"EXP"
	]


func add_to_groups(caller:Node, groups:Array):
	for group in groups:
		if GROUP_LIST.has(group):
			caller.add_to_group(group)
		else:
			print_debug("ERROR: <", group, "> DOES NOT EXIST")



#var crafting_options:Dictionary = {
#	"drone": {
#		"name":"Drone",
#		"scene":"res://lifeforms/drone.tscn",
#		"icon":"res://assets/visual/drone_plus.png",
#		"craft_time":3,
#		"craft_cost":1
#	},
#	"health":{
#		"name":"Health",
#		"icon":"res://assets/visual/health_plus.png",
#		"craft_time":5,
#		"craft_cost":3,
#	},
#	"mod":{
#		"name":"Mod",
#		"icon":"res://assets/visual/pcb_rect_plus.png",
#		"craft_time":2,
#		"craft_cost":3,
#	}
#}
