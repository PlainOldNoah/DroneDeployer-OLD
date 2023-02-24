extends Control

onready var drone_mirrors:Array = $ContentContainer/VBoxContainer.get_children()

var selected_drone:Drone = null
var center_mirror:int = 0
var drone_list_ref:Array = []


func _ready():
	center_mirror = ceil(drone_mirrors.size() / 2.0)
	drone_list_ref = Global.drone_manager.full_drone_list
	
#	initialize()



func initialize():
	var d_list_pivot:int = 0
	var d_count:int = drone_list_ref.size()
	
	drone_mirrors[0].set_drone(drone_list_ref[fmod((d_list_pivot - 4), -d_count)])
	drone_mirrors[1].set_drone(drone_list_ref[fmod((d_list_pivot - 3), -d_count)])
	drone_mirrors[2].set_drone(drone_list_ref[fmod((d_list_pivot - 2), -d_count)])
	drone_mirrors[3].set_drone(drone_list_ref[fmod((d_list_pivot - 1), -d_count)])
	
	drone_mirrors[4].set_drone(drone_list_ref[d_list_pivot])
	
	drone_mirrors[5].set_drone(drone_list_ref[fmod(d_list_pivot + 1, d_count)])
	drone_mirrors[6].set_drone(drone_list_ref[fmod(d_list_pivot + 2, d_count)])
	drone_mirrors[7].set_drone(drone_list_ref[fmod(d_list_pivot + 3, d_count)])
	drone_mirrors[8].set_drone(drone_list_ref[fmod(d_list_pivot + 4, d_count)])
