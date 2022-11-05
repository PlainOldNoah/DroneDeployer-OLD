class_name DroneManager
extends Node

signal drone_added_to_queue()
signal drone_launched()
signal queue_unordered()

var max_drones:int = 0
var curr_drone_count:int = 0

var stats_bar:Node = null
var launch_queue:Node = null
var drone_scene = preload("res://lifeforms/drone.tscn")
#export var launch_queue_scene:NodePath = ""

var drone_queue:Array = [] # Holds Drone datatype


func _ready():
	Global.drone_manager = self
	yield(get_tree().root, "ready")
	
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
	curr_drone_count += 1
	
	var drone_inst:Drone = drone_scene.instance()
	Global.level_manager.add_child(drone_inst)
	add_drone_to_queue(drone_inst)
	
	return drone_inst


# Deploys the next drone in the queue
func deploy_next_up(position:Vector2, rotation:float):
	if drone_queue.empty():
		return
		
	var drone_2_deploy:Drone = get_drone_from_queue(0)
	drone_2_deploy.init(position, rotation)
	
	stats_bar.update_drone_cnt(drone_queue.size() - 1, max_drones)
	emit_signal("drone_launched")
	
	drone_queue.remove(0)
	
#	emit_signal("queue_unordered")


# Puts the current drone to the back of the queue
func skip_up_next():
	if drone_queue.size() <= 1:
		return
	
	drone_queue.push_back(drone_queue.pop_front())
#	launch_queue.deploy_up_next(false)
	emit_signal("drone_launched", false)
#	emit_signal("queue_unordered")


# Return the idx drone from the queue
func get_drone_from_queue(idx:int=0) -> Drone:
	return null if drone_queue.size() == 0 else drone_queue[idx]


# Adds the drone to the end of the drone queue
func add_drone_to_queue(drone:Drone):
	drone_queue.append(drone)
	
	emit_signal("drone_added_to_queue", drone)
	
	stats_bar.update_drone_cnt(drone_queue.size(), max_drones)


# Handles drones returning from deployment and prepares them for relaunching
func collect_drone(drone:Drone):
	drone.disable()
	drone.global_position = Vector2.ONE * 100
	
	Logger.create("Drone collected " + str(drone.exp_held) + " exp")
	
	drone.exp_held = 0
	add_drone_to_queue(drone)
