extends Control

@onready var drone_queue_view := $MarginContainer/VBoxContainer/LeftSection/Buttons/DroneQueueView
@onready var drone_info_view := $MarginContainer/VBoxContainer/InfoBoxes/DroneInfoView
@onready var time_display := %TimeDisplay
@onready var drone_count_display := %DroneCountDisplay
@onready var score_display := %ScoreDisplay
@onready var scrap_display := %ScrapDisplay


func _ready():
	await get_tree().root.ready
	var _ok = DroneManager.connect("drone_queue_updated", _on_drone_order_changed)
	_ok = Global.game_manager.connect("playtime_updated", Callable(time_display, "update_time"))
	_ok = Global.game_manager.connect("curr_scrap_updated", _on_curr_scrap_changed)
	_ok = Global.game_manager.connect("score_updated", _on_score_updated)


func _on_drone_order_changed():
	drone_queue_view.redraw_queue()
	if not DroneManager.get_drone_queue().is_empty():
		drone_info_view.display_new_drone(DroneManager.drone_queue[0])
	
	drone_count_display.update_count(DroneManager.drone_queue.size(), DroneManager.max_drones)


func _on_curr_scrap_changed(value:int):
	score_display.set_value(value)


func _on_score_updated(value:int):
	scrap_display.set_value(value)
