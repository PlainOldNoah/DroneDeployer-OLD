extends Node

signal game_paused()

export var max_health:int = 3
export var max_drones:int = 0

onready var level_manager := $LevelManager
onready var gui := $GUI
onready var stats_bar := $GUI/StatsBar
onready var launch_queue := $GUI/LaunchQueue
onready var fabrication := $GUI/FabricatorMenu
onready var play_time_clock:Timer = $PlayTimeClock

var drone_scene = preload("res://lifeforms/drone.tscn")

var running:bool = false
var curr_drone_count:int = 0
var curr_health:int = 0
var curr_exp:int = 0
var score:int = 0
var curr_survived_sec:int = 0
var drone_queue:Array = []


func _ready():
	Global.game_manager = self
	set_max_drones(5)
	reset()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if running:
			stop_game()
		else:
			start_game()


# Calls the reset function for children nodes and puts variables to starting values
func reset():
	if running:
		stop_game()
	modify_health(max_health)
	stats_bar.reset()
	stats_bar.update_health(curr_health, max_health)
	stats_bar.update_drone_cnt(curr_drone_count, max_drones)


# Beings enemy spawning and play clock
func start_game():
	reset()
	print("Starting Game...")
	play_time_clock.start()
	running = true
	level_manager.start_spawn_clock(2)


# Stops enemy spawning and play clock
func stop_game():
	print("Stopping Game...")
	play_time_clock.stop()
	running = false
	level_manager.stop_spawn_clock()
	
	for i in get_tree().get_nodes_in_group("ENEMY"):
		i.queue_free()


# Unpauses if paused; pauses if unpaused
func toggle_pause(value:bool):
	get_tree().paused = value
	emit_signal("game_paused", value)


# Changes the max number of drones to count and builds the necessary amount
func set_max_drones(count:int):
	max_drones = max(0, count)
	stats_bar.update_drone_cnt(curr_drone_count, max_drones)
	
	var drones_2_make:int = max_drones - curr_drone_count
	for i in drones_2_make:
		create_new_drone()


# Easy setter to increase/decrease max drones by a value
func increment_max_drones(value:int):
	set_max_drones(max_drones + value)


# Creates a new drone scene and appends it to the queue
func create_new_drone():
	curr_drone_count += 1
	stats_bar.update_drone_cnt(curr_drone_count, max_drones)
	
	var drone_inst:KinematicBody2D = drone_scene.instance()
	Global.level_manager.add_child(drone_inst)
	add_drone_to_queue(drone_inst)
	return drone_inst


# Deploys the next drone in the queue
func deploy_next_up(position:Vector2, rotation:float):
	var drone_2_deploy:Drone = get_drone_from_queue(0)
	
	if drone_2_deploy == null:
		return
		
	drone_2_deploy.init(position, rotation)
	launch_queue.launch_up_next()
	drone_queue.remove(0)


# Puts the current drone to the back of the queue
func skip_up_next():
	drone_queue.push_back(drone_queue.pop_front())
	launch_queue.move_to_back(0)


# Return the idx drone from the queue
func get_drone_from_queue(idx:int=0) -> Drone:
	return null if drone_queue.size() == 0 else drone_queue[idx]


# Adds the drone to the end of the drone queue
func add_drone_to_queue(drone:Drone):
	drone_queue.append(drone)
	launch_queue.add_to_queue(drone)


# Adds value to the current exp and emits a signal
func set_curr_exp(value:int):
	curr_exp += value
	if curr_exp < 0:
		print_debug("INVALID VALUE: exp is a negative")
	fabrication.queue_2_core()


# Add the 'value' to the total gathered exp
func exp_retrieved(value:int):
	score += value
	set_curr_exp(value)
	
	stats_bar.update_curr_exp(curr_exp)
	stats_bar.update_score(score)


# Changes the current health. + to heal, - to hurt
func modify_health(value:int):
	curr_health = clamp(curr_health + value, 0, max_health)
	if curr_health <= 0:
		print("DEAD")
		stop_game()
	stats_bar.update_health(curr_health, max_health)


# Takes a positive damage value and negates it for modify health
func take_hit(damage:int):
	modify_health(-damage)


# Increments the amount of time by a second
func _on_PlayTimeClock_timeout():
	curr_survived_sec += 1
	stats_bar.update_time(curr_survived_sec)
	play_time_clock.start()
