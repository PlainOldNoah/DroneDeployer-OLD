class_name GameManager
extends Node

signal game_paused()
signal drone_order_changed()

export var max_health:int = 3
export var max_drones:int = 0
export var deploy_cooldown:float = 0.5

onready var level_manager := $LevelManager
onready var drone_manager := $DroneManager
onready var gui := $GUI
onready var stats_bar := $GUI/VBoxContainer/StatsBar
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

var drone_queue:Array = [] # Holds Drone datatype


func _ready():
	Global.game_manager = self
	yield(get_tree().root, "ready")
	drone_manager.set_max_drones(max_drones)
	call_deferred("reset")


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
#	emit_signal("drone_order_changed", get_drone_from_queue(0))
	Logger.clear()


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
	
	for i in get_tree().get_nodes_in_group("DRONE"):
		i.set_vel_to_hub()


# Unpauses if paused; pauses if unpaused
func toggle_pause(value:bool):
	get_tree().paused = value
	emit_signal("game_paused", value)


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


# Increases or decreases the current health. + to heal, - to hurt
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
