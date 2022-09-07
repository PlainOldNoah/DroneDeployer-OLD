extends CanvasLayer

enum MENUS {NONE, FABRICATOR}
var current_menu:int = MENUS.NONE

onready var curr_exp_label:Label = get_node("%CurrentExp")
onready var score_label:Label = get_node("%Score")
onready var time_label:Label = get_node("%Time")
onready var drone_count_label:Label = get_node("%DroneCount")

onready var background:ColorRect = get_node("BackgroundFade")
onready var fabricator_menu:Control = get_node("FabricatorMenu")


func _ready():
	yield(get_tree().root, "ready")
	reset()
	dismiss_menu()


func _input(event):
	if event.is_action_pressed("fabricator_menu"):
		if current_menu == MENUS.FABRICATOR:
			dismiss_menu()
		else:
			request_menu(MENUS.FABRICATOR)
	elif event.is_action_pressed("ui_cancel"):
		dismiss_menu()


# Makes requested menu visible
func request_menu(menu:int):
	Global.game_manager.toggle_pause(true)
	
	match menu:
		MENUS.FABRICATOR:
			fabricator_menu.show()
			current_menu = MENUS.FABRICATOR
	background.show()


# Hides all GUI menus
func dismiss_menu():
	Global.game_manager.toggle_pause(false)
	
	background.hide()
	fabricator_menu.hide()
	current_menu = MENUS.NONE


func reset():
	update_curr_exp(0)
	update_score(0)
	update_time(0)
	update_drone_cnt(0)

func update_curr_exp(new_exp:int):
	curr_exp_label.text = "Exp: " + str(new_exp)


func update_score(new_score:int):
	score_label.text = "Score: " + str(new_score)


func update_time(new_seconds:int):
	var minutes:int = new_seconds / 60
	var seconds:int = new_seconds % 60
	time_label.text = "Time: " + str(minutes) + ":" + str(seconds).pad_zeros(2)


func update_drone_cnt(count:int):
	drone_count_label.text = "Drones: " + str(count)
