class_name GameManager
extends Node

signal health_changed()
signal playtime_updated()
signal curr_scrap_updated()
signal spent_scrap_updated()
signal score_updated()

@export var max_health:int = 3
@export var max_drones:int = 1
@export var drone_deploy_cooldown:float = 0.5
@export var drone_skip_cooldown:float = 0.25

@onready var play_time_clock:Timer = $PlayTimeClock

var running:bool = false

var curr_drone_count:int = 0
var curr_health:int = 0
var curr_scrap:int = 0
var spent_scrap:int = 0
var score:int = 0
var curr_survived_sec:int = 0


func _ready():
	Global.game_manager = self
	await get_tree().root.ready
	
	DroneManager.set_max_drones(max_drones)
	call_deferred("reset")


# Calls the reset function for children nodes and puts variables to starting values
func reset():
	if running:
		stop_game()
		
	modify_health(max_health)
	reset_exp()
	curr_survived_sec = 0
	Logger.clear()


# Beings enemy spawning and play clock
func start_game():
	reset()
	Logger.create(self, "system", "Starting Game")
	play_time_clock.start()
	running = true
	EnemyManager.toggle_spawning(true)


# Stops enemy spawning and play clock
func stop_game():
	Logger.create(self, "system", "Game Ending")
	play_time_clock.stop()
	running = false
	EnemyManager.toggle_spawning(false)
	
	for i in get_tree().get_nodes_in_group("ENEMY"):
		i.queue_free()
	
	for i in get_tree().get_nodes_in_group("DRONE"):
		if i.state != Drone.STATES.IDLE:
			DroneManager.add_drone_to_queue(i)
			i.reset()
	
	for i in get_tree().get_nodes_in_group("EXP"):
		i.queue_free()
	
	for i in get_tree().get_nodes_in_group("DEBRIS"):
		i.queue_free()


# Unpauses if paused; pauses if unpaused
func toggle_pause(value:bool):
	get_tree().paused = value


# Adds the value to the current available scrap
func add_available_scrap(value:int):
	curr_scrap += value
	emit_signal("curr_scrap_updated", curr_scrap)
	
	if curr_scrap < 0:
		print_debug("INVALID VALUE: exp is a negative")
		
	Global.fabricator.queue_to_core()


# Adds the value to the spent scrap total
func add_spent_scrap(value:int):
	spent_scrap += value
	emit_signal("spent_scrap_updated", spent_scrap)


# Adds the value to the current score
func increase_score(value:int):
	score += value
	emit_signal("score_updated", score)


# Sets exp to 0
func reset_exp():
	curr_scrap = 0
	score = 0


# Increases or decreases the current health. + to heal, - to hurt
func modify_health(value:int):
	curr_health = clamp(curr_health + value, 0, max_health)
	emit_signal("health_changed", curr_health, max_health)
	if curr_health <= 0:
		Logger.create(self, "hub", "Dead")
		Global.gui.request_menu(Global.gui.MENUS.GAMEOVER)
		stop_game()


# Takes a positive damage value and negates it for modify health
func take_hit(damage:int):
	modify_health(-damage)


# Returns curr_survived_sec
func get_playtime() -> int:
	return curr_survived_sec


# Increments the amount of time by a second
func _on_PlayTimeClock_timeout():
	curr_survived_sec += 1
	emit_signal("playtime_updated", get_playtime())
