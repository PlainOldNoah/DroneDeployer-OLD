extends Node

var tile_size:int = 32

var game_manager:GameManager = null
var hub_scene:Hub = null
var drone_manager:DroneManager = null
var level_manager:LevelManager = null
var gui:GUI = null
var stats_bar:MarginContainer = null


var crafting_options:Dictionary = {
	"drone": {
		"name":"Drone",
		"scene":"res://lifeforms/drone.tscn",
		"icon":"res://assets/visual/small_drone.png",
		"craft_time":3,
		"craft_cost":1
	},
	"health":{
		"name":"Health",
		"icon":"res://assets/visual/health_plus.png",
		"craft_time":5,
		"craft_cost":3,
	}
}
