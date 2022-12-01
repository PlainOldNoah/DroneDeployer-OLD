class_name DroneManager
extends Node

signal drone_created()
signal drone_added_to_queue()
signal drone_launched()
signal drone_queue_changed()
signal relay_drone_stats_changed()

onready var drone_info_view := $"../GUI/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/DroneInfoView"

var max_drones:int = 0
var curr_drone_count:int = 0
var stats_bar:Node = null
var launch_queue:Node = null
var drone_scene = preload("res://lifeforms/drone.tscn")

var drone_queue:Array = [] # Holds Drone datatype


func _ready():
	Global.drone_manager = self
	yield(get_tree().root, "ready")
	var _ok := connect("drone_queue_changed", drone_info_view, "display_new_drone")
	_ok = connect("relay_drone_stats_changed", drone_info_view, "_on_drone_stats_changed")
	_ok = connect("relay_drone_stats_changed", Global.engr_menu, "_on_drone_stats_changed")
	
	stats_bar = Global.gui.get_menu("stats_bar")
	launch_queue = Global.gui.get_menu("launch_queue")


# Changes the max number of drones to count and builds the necessary amount
func set_max_drones(count:int):
	max_drones = max(0, count)
	
	var drones_2_make:int = max_drones - curr_drone_count
	for i in drones_2_make:
		create_new_drone()


# Easy setter to increase/decrease max drones by a value
func increment_max_drones(value:int):
	set_max_drones(max_drones + value)


# Creates a new drone scene and appends it to the queue
func create_new_drone():
	var drone_inst:Drone = drone_scene.instance()
	var _ok := drone_inst.connect("stats_updated", self, "relay_drone_stats_updated")
	Global.level_manager.add_child(drone_inst)
	add_drone_to_queue(drone_inst)
	
	curr_drone_count += 1
	emit_signal("drone_created", drone_inst)


# Deploys the next drone in the queue
func deploy_next_up(position:Vector2, rotation:float):
	if drone_queue.empty():
		return
		
	var drone_2_deploy:Drone = get_drone_from_queue(0)
	drone_2_deploy.init(position, rotation)
	
	stats_bar.update_drone_cnt(drone_queue.size() - 1, max_drones)
	
	drone_queue.remove(0)
	
	emit_signal("drone_launched", true)
	emit_signal("drone_queue_changed", get_drone_from_queue(0))


# Puts the current drone to the back of the queue
func skip_up_next():
	if drone_queue.size() <= 1:
		return
	
	drone_queue.push_back(drone_queue.pop_front())
	
	emit_signal("drone_queue_changed", get_drone_from_queue(0))
	emit_signal("drone_launched", false)


# Return the idx drone from the queue
func get_drone_from_queue(idx:int=0) -> Drone:
	return null if drone_queue.empty() else drone_queue[idx]


# Adds the drone to the end of the drone queue
func add_drone_to_queue(drone:Drone):
	drone_queue.append(drone)
	
	emit_signal("drone_added_to_queue", drone)
	emit_signal("drone_queue_changed", get_drone_from_queue(0))
	
	stats_bar.update_drone_cnt(drone_queue.size(), max_drones)


# Handles drones returning from deployment and prepares them for relaunching
func collect_drone(drone:Drone):
	drone.calculate_stats()
	
	drone.disable()
	drone.global_position = Vector2.ONE * 100
	
	Logger.create(self, "drone", "Drone collected " + str(drone.exp_held) + " exp")
	
	drone.exp_held = 0
	add_drone_to_queue(drone)


# Returns the drone queue
func get_drone_queue():
	return drone_queue


# When a drones stat's change it emits the "stats_changed" signal, this relays it more broadly
func relay_drone_stats_updated(d:Drone):
	emit_signal("relay_drone_stats_changed", d)
