extends CanvasLayer

enum MENUS {NONE, FABRICATOR}
var current_menu:int = MENUS.NONE

onready var stats_bar:MarginContainer = $HBoxContainer/VBoxContainer/StatsBar
onready var drone_info:MarginContainer = $HBoxContainer/VBoxContainer/DroneInfoView
onready var launch_queue:Control = $HBoxContainer/LaunchQueue

onready var background:ColorRect = get_node("BackgroundFade")
onready var fabricator_menu:Control = get_node("FabricatorMenu")


func _ready():
	Global.gui = self
	yield(get_tree().root, "ready")
	stats_bar.reset()
	drone_info.reset()
	fabricator_menu.reset()
	dismiss_menu()


func _input(event):
	if event.is_action_pressed("fabricator_menu"):
		if current_menu == MENUS.FABRICATOR:
			dismiss_menu()
		else:
			request_menu(MENUS.FABRICATOR)
	elif event.is_action_pressed("ui_cancel"):
		dismiss_menu()


# Returns a child menu
func get_menu(menu:String) -> Node:
	match menu:
		"stats_bar":
			return stats_bar
		"drone_info_view":
			return drone_info
		"launch_queue":
			return launch_queue
		"fabricator":
			return fabricator_menu
		_:
			print_debug("ERROR: Menu <", menu, "> does not exist")
			return null


# Middle function to connect GUI to stats bar
func update_stats(label:String, values:Array):
	stats_bar.update_label(label, values)


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
