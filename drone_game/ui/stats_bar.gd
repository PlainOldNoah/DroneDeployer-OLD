extends Control

onready var curr_exp_label:Label = get_node("%CurrentExp")
onready var score_label:Label = get_node("%Score")
onready var time_label:Label = get_node("%Time")
onready var drone_count_label:Label = get_node("%DroneCount")
onready var health_label:Label = get_node("%Health")


func update_label(stat:String, values:Array):
	match stat:
		"HEALTH": 
			update_health(values[0], values[1])
		"CURR_EXP": 
			update_curr_exp(values[0])
		"SCORE": 
			update_score(values[0])
		"TIME": 
			update_time(values[0])
		"DRONE_CNT": 
			update_drone_cnt(values[0], values[1])
		_:
			print_debug("ERROR: <", stat, "> menu not found")


func reset():
	update_curr_exp(0)
	update_score(0)
	update_time(0)


func update_health(curr_health:int, max_health:int):
	health_label.text = "Health: " + str(curr_health) + "/" + str(max_health)


# Changes the current exp label
func update_curr_exp(new_exp:int):
	curr_exp_label.text = "Exp: " + str(new_exp)


# Changes the score label
func update_score(new_score:int):
	score_label.text = "Score: " + str(new_score)


# Converts time to minutes and seconds and changes the label
func update_time(new_seconds:int):
	var minutes:int = new_seconds / 60
	var seconds:int = new_seconds % 60
	time_label.text = "Time: " + str(minutes) + ":" + str(seconds).pad_zeros(2)


# Changes the drone count label
func update_drone_cnt(current:int, max_drones:int):
	drone_count_label.text = "Drones: " + str(current) + "/" + str(max_drones)
