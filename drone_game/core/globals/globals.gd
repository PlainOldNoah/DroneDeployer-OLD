extends Node

var tile_size:int = 32

var game_manager:GameManager = null
var drone_manager:Node = null
var level_manager:Node = null
var gui:CanvasLayer = null
var hub_scene:Hub = null

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
