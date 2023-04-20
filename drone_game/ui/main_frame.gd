extends Control

@onready var drone_queue_view := $MarginContainer/VBoxContainer/LeftSection/Buttons/DroneQueueView
@onready var drone_info_view := $MarginContainer/VBoxContainer/InfoBoxes/DroneInfoView
@onready var time_display := %TimeDisplay
@onready var drone_count_display := %DroneCountDisplay
@onready var score_display := %ScoreDisplay
@onready var scrap_display := %ScrapDisplay


func _ready():
	await get_tree().root.ready
	var _ok = Global.drone_manager.connect("drone_queue_updated", _on_drone_order_changed)
	_ok = Global.game_manager.connect("playtime_updated", Callable(time_display, "update_time"))
	_ok = Global.game_manager.connect("score_changed", _on_score_changed)


func _on_drone_order_changed():
	drone_queue_view.redraw_queue()
	if not Global.drone_manager.drone_queue.is_empty():
		drone_info_view.display_new_drone(Global.drone_manager.drone_queue[0])
	
	drone_count_display.update_count(Global.drone_manager.drone_queue.size(), Global.drone_manager.max_drones)


func _on_score_changed(curr_exp:int, score:int):
	score_display.set_value(curr_exp)
	scrap_display.set_value(score)
