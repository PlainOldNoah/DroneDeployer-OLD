extends Control

@onready var mirror_container := $ContentContainer/HBoxContainer
#$"../../../InfoBoxes/DroneInfoView"

#func _ready():
#	var _ok = Global.drone_manager.connect("drone_queue_updated", redraw_queue)


func redraw_queue():
#	await get_tree().create_timer(0.05).timeout
	for i in mirror_container.get_child_count():
		var focused_mirror := mirror_container.get_child(mirror_container.get_child_count() - i - 1)
		
		if Global.drone_manager.drone_queue.size() > i:
			focused_mirror.set_drone(Global.drone_manager.drone_queue[i])
			focused_mirror.modulate.a = 1.0
		else:
			focused_mirror.reset()



#func toggle_mirror_visible(state:bool):
#	for i in mirror_container.get_children():
#
#		if state:
#			i.modulate.a = 1.0
#		else:
#			i.modulate.a = 0.0


# Hide drones mirrors right to left
#func cascade_hide():
#	for i in range(mirror_container.get_child_count() - 1, -1, -1):
#		mirror_container.get_child(i).modulate.a = 0.0
#		await get_tree().process_frame


#func cascade_show():
#	for i in range(mirror_container.get_child_count() - 1, -1, -1):
#		mirror_container.get_child(i).modulate.a = 1.0
#		await get_tree().process_frame
