class_name GUI
extends CanvasLayer

enum MENUS {NONE, FABRICATOR, DEBUG, ENGR, MAIN, GAMEOVER, PAUSE}
var current_menu:int = MENUS.NONE

@onready var stats_bar:Control = find_child("StatsBar")
@onready var drone_info:Control = find_child("DroneInfoView")
@onready var launch_queue:Control = find_child("LaunchQueue")
@onready var background:ColorRect = get_node("BackgroundFade")
@onready var fabricator_menu:Control = get_node("FabricatorMenu")
@onready var engineering_menu:Control = get_node("EngineeringMenu")
@onready var debug_menu:Control = get_node("DebugMenu")
@onready var main_menu:Control = get_node("MainMenu")
@onready var game_over_menu:Control = get_node("GameOverMenu")
@onready var pause_menu:Control = get_node("PauseMenu")

var menu_lockout:bool = false # Allows/Prevents user from requesting new menus w/ hotkeys

func _ready():
	Global.gui = self
	await get_tree().root.ready
	stats_bar.reset()
	drone_info.reset()
	fabricator_menu.reset()
#	dismiss_menu()


func _input(event):
	if menu_lockout:
		if event.is_action_pressed("pause"): # Lets pause work without allowing others
			dismiss_menu()
		return
	
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
	
	elif event.is_action_pressed("pause"):
		print("pause event")
		if current_menu == MENUS.NONE:
			request_menu(MENUS.PAUSE)
		else:
			dismiss_menu()
		
	elif event.is_action_pressed("ui_cancel"):
		dismiss_menu()


# Shows the requested menu
func request_menu(menu:int):
	print("REQUESTING MENU")
	
	dismiss_menu()
	Global.game_manager.toggle_pause(true)
	
	match menu:
		MENUS.FABRICATOR:
			fabricator_menu.visible = true
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
			menu_lockout = true
		MENUS.GAMEOVER:
			game_over_menu.show()
			current_menu = MENUS.GAMEOVER
			menu_lockout = true
		MENUS.PAUSE:
			pause_menu.show()
			current_menu = MENUS.PAUSE
			menu_lockout = true
	background.show()


# Hides all GUI menus
func dismiss_menu():
	Global.game_manager.toggle_pause(false)
	menu_lockout = false
	
	background.hide()
	fabricator_menu.hide()
	debug_menu.hide()
	engineering_menu.hide()
	main_menu.hide()
	game_over_menu.hide()
	pause_menu.hide()
	current_menu = MENUS.NONE
