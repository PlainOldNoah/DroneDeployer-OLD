class_name GameManager
extends Node

signal game_paused()

@export var max_health:int = 3
@export var max_drones:int = 1
@export var deploy_cooldown:float = 0.5

@onready var play_time_clock:Timer = $PlayTimeClock

var running:bool = false
var curr_drone_count:int = 0
var curr_health:int = 0
var curr_exp:int = 0
var score:int = 0
var curr_survived_sec:int = 0

#var drone_queue:Array = [] # Holds Drone datatype


func _ready():
	Global.game_manager = self
	await get_tree().root.ready
	
	Global.drone_manager.set_max_drones(max_drones)
	call_deferred("reset")


#func _input(event): # DEBUG
#	if event.is_action_pressed("ui_accept"):
#		if running:
#			stop_game()
#		else:
#			start_game()


# Calls the reset function for children nodes and puts variables to starting values
func reset():
	if running:
		stop_game()
		
	modify_health(max_health)
	reset_exp()
	curr_survived_sec = 0
#	Global.stats_bar.reset()
#	Global.stats_bar.update_health(curr_health, max_health)
#	Global.stats_bar.update_drone_cnt(max_drones, max_drones)
	Logger.clear()


# Beings enemy spawning and play clock
func start_game():
	reset()
	Logger.create(self, "system", "Starting Game")
	play_time_clock.start()
#	Global.level_manager.prepare_map()
	running = true
#	Global.level_manager.start_enemy_spawning(2)
	Global.enemy_manager.toggle_spawning(true)


# Stops enemy spawning and play clock
func stop_game():
	Logger.create(self, "system", "Game Ending")
	play_time_clock.stop()
	running = false
	Global.enemy_manager.toggle_spawning(false)
#	Global.level_manager.stop_enemy_spawning()
	
	for i in get_tree().get_nodes_in_group("ENEMY"):
		i.queue_free()
	
	for i in get_tree().get_nodes_in_group("DRONE"):
		if i.state != Drone.STATES.IDLE:
			Global.drone_manager.add_drone_to_queue(i)
			i.reset()
	
	for i in get_tree().get_nodes_in_group("EXP"):
		i.queue_free()


# Unpauses if paused; pauses if unpaused
func toggle_pause(value:bool):
	get_tree().paused = value
	emit_signal("game_paused", value)


# Adds the value to the current exp/score
func add_exp(value:int):
	curr_exp += value
	score += value
	
#	Global.stats_bar.update_curr_exp(curr_exp)
#	Global.stats_bar.update_score(score)
	
	if curr_exp < 0:
		print_debug("INVALID VALUE: exp is a negative")
	Global.fabricator.queue_to_core()


# Sets exp to 0
func reset_exp():
	curr_exp = 0
	score = 0
#	Global.stats_bar.update_curr_exp(curr_exp)
#	Global.stats_bar.update_score(score)


# Increases or decreases the current health. + to heal, - to hurt
func modify_health(value:int):
	curr_health = clamp(curr_health + value, 0, max_health)
	if curr_health <= 0:
		Logger.create(self, "hub", "Dead")
		Global.gui.request_menu(Global.gui.MENUS.GAMEOVER)
		stop_game()
#	Global.stats_bar.update_health(curr_health, max_health)


# Takes a positive damage value and negates it for modify health
func take_hit(damage:int):
	modify_health(-damage)


# Returns curr_survived_sec
func get_playtime() -> int:
	return curr_survived_sec


# Increments the amount of time by a second
func _on_PlayTimeClock_timeout():
	curr_survived_sec += 1
#	Global.stats_bar.update_time(curr_survived_sec)
#	play_time_clock.start()
