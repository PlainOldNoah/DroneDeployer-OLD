extends Node

var tile_size:int = 32

var game_manager:GameManager = null
var drone_manager:DroneManager = null
var mod_manager = null
var level_manager:LevelManager = null
var hub_scene:Hub = null
var gui:GUI = null
var stats_bar:MarginContainer = null


var crafting_options:Dictionary = {
	"drone": {
		"name":"Drone",
		"scene":"res://lifeforms/drone.tscn",
		"icon":"res://assets/visual/drone_plus.png",
		"craft_time":3,
		"craft_cost":1
	},
	"health":{
		"name":"Health",
		"icon":"res://assets/visual/health_plus.png",
		"craft_time":5,
		"craft_cost":3,
	},
	"mod":{
		"name":"Mod",
		"icon":"res://assets/visual/pcb_rect_plus.png",
		"craft_time":5,
		"craft_cost":3,
	}
}
