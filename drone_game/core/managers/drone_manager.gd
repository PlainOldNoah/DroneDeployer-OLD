class_name DroneManager
extends Node

signal drone_created()
signal drone_added_to_queue()
signal drone_launched()
signal drone_skipped()
signal drone_queue_updated() # Emit when drone queue order changes

var max_drones:int = 0
var curr_drone_count:int = 0
var drone_scene = preload("res://lifeforms/drone.tscn")

var full_drone_list:Array = []
var drone_queue:Array = [] # Holds Drone datatype


func _ready():
	Global.drone_manager = self
	await get_tree().root.ready


# Easy setter to increase/decrease max drones by a value
func increment_max_drones(value:int):
	set_max_drones(max_drones + value)


# Changes the max number of drones to count and builds the necessary amount
func set_max_drones(count:int):
	max_drones = max(0, count)
	
	var drones_2_make:int = max_drones - curr_drone_count
	for i in drones_2_make:
		create_new_drone()


# Creates a new drone scene and appends it to the queue
func create_new_drone():
	var drone_inst:Drone = drone_scene.instantiate()
	Global.gameboard.add_object(drone_inst)
#	Global.level_manager.add_child(drone_inst)
	add_drone_to_queue(drone_inst)
	
	curr_drone_count += 1
	full_drone_list.append(drone_inst)
	emit_signal("drone_created", drone_inst)


# Deploys the next drone in the queue
func deploy_next_up(position:Vector2, rotation:float):
	if drone_queue.is_empty():
		return
		
	var drone_2_deploy:Drone = get_drone_from_queue(0)
	drone_2_deploy.init(position, rotation)
	
#	Global.stats_bar.update_drone_cnt(drone_queue.size() - 1, max_drones)
	
	drone_queue.remove_at(0)
	
	emit_signal("drone_launched", drone_2_deploy)
	emit_signal("drone_queue_updated")


# Puts the current drone to the back of the queue
func skip_up_next():
	if drone_queue.size() <= 1:
		return
	
	drone_queue.push_back(drone_queue.pop_front())
	
	emit_signal("drone_queue_updated")
	emit_signal("drone_skipped")


# Return the idx drone from the queue
func get_drone_from_queue(idx:int=0) -> Drone:
	return null if drone_queue.is_empty() else drone_queue[idx]


# Adds the drone to the end of the drone queue
func add_drone_to_queue(drone:Drone):
	if drone_queue.has(drone): # This should stop drones duplicating
		print("WARNING: drone queue already contains <", drone, ">")
		return
		
	drone.global_position = Vector2.ZERO
	drone_queue.append(drone)
	
	emit_signal("drone_added_to_queue", drone)
	emit_signal("drone_queue_updated")


# Handles drones returning from deployment and prepares them for relaunching
func collect_drone(drone:Drone):
	drone.set_state(drone.STATES.IDLE)
	
	Logger.create(self, "drone", drone.name + " collected " + str(drone.exp_held) + " exp")
	
	Global.game_manager.add_exp(drone.exp_held)
	drone.exp_held = 0
	
	add_drone_to_queue(drone)


# Returns the drone queue
func get_drone_queue():
	return drone_queue
