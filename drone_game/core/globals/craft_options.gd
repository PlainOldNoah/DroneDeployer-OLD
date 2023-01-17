extends Node


# Fabricator items with references and values
var fabricator_items:Dictionary = {
	"drone": {
		"name":"Drone",
		"scene":"res://lifeforms/drone.tscn",
		"icon":"res://assets/visual/menu/drone_plus_128.png",
		"craft_time":3,
		"craft_cost":1
	},
	"health":{
		"name":"Health",
		"icon":"res://assets/visual/menu/health_plus_128.png",
		"craft_time":5,
		"craft_cost":3,
	},
	"mod":{
		"name":"Mod",
		"icon":"res://assets/visual/menu/pcb_circle_plus_128.png",
		"craft_time":2,
		"craft_cost":3,
	}
}


# Drone enhancements with weights and values
var enhancements:Dictionary = {
	"max_battery": {
		"weight": 2, # weight for drawing enhancement
		"tiers": { # weight and value for each sub-tier
			"T1":{
				"weight": 80,
				"values": [10,25],
			},
			"T2":{
				"weight": 50,
				"values": [26,50],
			},
			"T3":{
				"weight": 20,
				"values": [51,75],
			},
			"T4":{
				"weight": 10,
				"values": [76,100],
			},
		}
	},
	
	"battery_drain": {
		"weight": 1, # weight for drawing enhancement
		"tiers": { # weight and value for each sub-tier
			"T1":{
				"weight": 50,
				"values": [1,2],
			},
			"T2":{
				"weight": 20,
				"values": [3,5],
			},
			"T3":{
				"weight": 10,
				"values": [6,10],
			},
			"T4":{
				"weight": 1,
				"values": [11,20],
			},
		}
	},
	
	"speed": {
		"weight": 1, # weight for drawing enhancement
		"tiers": { # weight and value for each sub-tier
			"T1":{
				"weight": 50,
				"values": [10,20],
			},
			"T2":{
				"weight": 40,
				"values": [30,50],
			},
			"T3":{
				"weight": 10,
				"values": [60,90],
			},
			"T4":{
				"weight": 1,
				"values": [100,200],
			},
		}
	},
	
	"damage": {
		"weight": 1, # weight for drawing enhancement
		"tiers": { # weight and value for each sub-tier
			"T1":{
				"weight": 50,
				"values": [1,3],
			},
			"T2":{
				"weight": 40,
				"values": [4,6],
			},
			"T3":{
				"weight": 10,
				"values": [7,11],
			},
			"T4":{
				"weight": 1,
				"values": [12,20],
			},
		}
	},
	
	"crit_chance": {
		"weight": 1, # weight for drawing enhancement
		"tiers": { # weight and value for each sub-tier
			"T1":{
				"weight": 60,
				"values": [1,5],
			},
			"T2":{
				"weight": 40,
				"values": [6,12],
			},
			"T3":{
				"weight": 20,
				"values": [13,20],
			},
			"T4":{
				"weight": 5,
				"values": [21,30],
			},
		}
	},
	
	"crit_dmg_mult": {
		"weight": 1, # weight for drawing enhancement
		"tiers": { # weight and value for each sub-tier
			"T1":{
				"weight": 80,
				"values": [1,1],
			},
			"T2":{
				"weight": 50,
				"values": [2,2],
			},
			"T3":{
				"weight": 10,
				"values": [3,3],
			},
			"T4":{
				"weight": 5,
				"values": [4,5],
			},
		}
	},
	
	"bounces": {
		"weight": 1, # weight for drawing enhancement
		"tiers": { # weight and value for each sub-tier
			"T1":{
				"weight": 50,
				"values": [1,5],
			},
			"T2":{
				"weight": 40,
				"values": [6,10],
			},
			"T3":{
				"weight": 10,
				"values": [11,15],
			},
			"T4":{
				"weight": 2,
				"values": [16,20],
			},
		}
	},
	
}
