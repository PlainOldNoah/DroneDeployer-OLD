class_name GUI
extends CanvasLayer

enum MENUS {NONE, FABRICATOR, DEBUG, ENGR, MAIN, GAMEOVER}
var current_menu:int = MENUS.NONE

onready var stats_bar:Control = find_node("StatsBar")
onready var drone_info:Control = find_node("DroneInfoView")
onready var launch_queue:Control = find_node("LaunchQueue")
onready var background:ColorRect = get_node("BackgroundFade")
onready var fabricator_menu:Control = get_node("FabricatorMenu")
onready var engineering_menu:Control = get_node("EngineeringMenu")
onready var debug_menu:Control = get_node("DebugMenu")
onready var main_menu:Control = get_node("MainMenu")
onready var game_over_menu:Control = get_node("GameOverMenu")


func _ready():
	Global.gui = self
	yield(get_tree().root, "ready")
	stats_bar.reset()
	drone_info.reset()
	fabricator_menu.reset()
#	dismiss_menu()


func _input(event):
	if event.is_action_pressed("fabricator_menu"):
		if current_menu == MENUS.FABRICATOR:
			dismiss_menu()
		else:
			request_menu(MENUS.FABRICATOR)
	elif event.is_action_pressed("toggle_debug"):
		if current_menu == MENUS.DEBUG:
			dismiss_menu()
		else:
			request_menu(MENUS.DEBUG)
	elif event.is_action_pressed("engr_menu"):
		if current_menu == MENUS.ENGR:
			dismiss_menu()
		else:
			request_menu(MENUS.ENGR)
	elif event.is_action_pressed("ui_cancel"):
		dismiss_menu()


# Shows the requested menu
func request_menu(menu:int):
	dismiss_menu()
	Global.game_manager.toggle_pause(true)
	
	match menu:
		MENUS.FABRICATOR:
			fabricator_menu.show()
			current_menu = MENUS.FABRICATOR
		MENUS.DEBUG:
			debug_menu.show()
			current_menu = MENUS.DEBUG
		MENUS.ENGR:
			engineering_menu.show()
			current_menu = MENUS.ENGR
		MENUS.MAIN:
			main_menu.show()
			current_menu = MENUS.MAIN
		MENUS.GAMEOVER:
			game_over_menu.show()
			current_menu = MENUS.GAMEOVER
	background.show()


# Hides all GUI menus
func dismiss_menu():
	Global.game_manager.toggle_pause(false)
	
	background.hide()
	fabricator_menu.hide()
	debug_menu.hide()
	engineering_menu.hide()
	main_menu.hide()
	game_over_menu.hide()
	current_menu = MENUS.NONE


func adjust_gui_scales(): # DEBUG FUNCTION
	var scale_factor:int = $GameBackground.rect_scale.x
	$MarginContainer.add_constant_override("margin_bottom", scale_factor * 8) # Scale factor times number of pixles that make up the border
	$MarginContainer.add_constant_override("margin_left", scale_factor * 8)
	$MarginContainer.add_constant_override("margin_right", scale_factor * 8)
	$MarginContainer.add_constant_override("margin_top", scale_factor * 8)
