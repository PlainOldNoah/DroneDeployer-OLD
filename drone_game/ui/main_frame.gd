extends Control

@onready var drone_queue_view := $MarginContainer/VBoxContainer/LeftSection/Buttons/DroneQueueView
@onready var drone_info_view := $MarginContainer/VBoxContainer/InfoBoxes/DroneInfoView


func _ready():
	var _ok = Global.drone_manager.connect("drone_queue_updated", _on_drone_order_changed)


func _on_drone_order_changed():
	drone_queue_view.redraw_queue()
	drone_info_view.display_new_drone(Global.drone_manager.drone_queue[0])
