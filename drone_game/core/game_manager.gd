extends Node

signal game_paused()

onready var level_manager := $LevelManager
onready var gui:CanvasLayer = $GUI
onready var play_time_clock:Timer = $PlayTimeClock

var running:bool = false
var max_drones:int = 0
var curr_exp:int = 0
var score:int = 0
var curr_survived_sec:int = 0


func _ready():
	Global.game_manager = self
	reset()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if running:
			stop_game()
		else:
			start_game()


# Unpauses if paused; pauses if unpaused
func toggle_pause(value:bool):
	get_tree().paused = value
	emit_signal("game_paused", value)


func set_max_drones(count:int):
	max_drones = max(0, count)
	$GUI.call_deferred("update_drone_cnt", max_drones) # TODO: Make this more dynamic


# Calls the reset function for children nodes and puts variables to starting values
func reset():
	gui.reset()
	set_max_drones(1)


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


# Add the 'value' to the total gathered exp
func exp_retrieved(value:int):
	score += value
	curr_exp += value
	gui.update_curr_exp(curr_exp)
	gui.update_score(score)


# Increments the amount of time by a second
func _on_PlayTimeClock_timeout():
	curr_survived_sec += 1
	gui.update_time(curr_survived_sec)
	play_time_clock.start()


# Reduces current exp and creates a new available drone
func build_new_drone():
#	if curr_exp >= 3:
#		curr_exp -= 3
#		gui.update_curr_exp(curr_exp)
	set_max_drones(max_drones + 1)
