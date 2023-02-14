extends Control

func _ready():
	Global.engr_menu = self
	yield(get_tree().root, "ready")
	
	var _ok = Global.drone_manager.connect("drone_created", self, "add_drone_mirror")
	_ok = Global.drone_manager.connect("drone_launched", self, "update_drone_display")
	_ok = Global.drone_manager.connect("drone_added_to_queue", self, "update_drone_display")
	_ok = Global.mod_manager.connect("enhancement_created", self, "add_free_enhancement")


# Called when the GUI brings up this menu
func on_open():
	pass


# Called when this menu is hidden by the GUI
func on_close():
	pass
#	drone_info_view.reset()
#	selected_drone_mirror.reset()
#	selected_drone = null
#	for i in equipped_mods_view.get_children():
#		i.queue_free()
#	for i in available_mods_view.get_children():
#		i.toggle_popup(false)
#	for i in drone_display.get_children():
#		i.toggle_popup(false)


func add_drone_mirror(drone:Drone):
	pass


func update_drone_display(_drone:Drone):
	pass


func add_free_enhancement(new_enhance:Dictionary):
	pass


func _on_EngineeringMenu_visibility_changed():
	if visible:
		on_open()
	else:
		on_close()


func _on_DroneSelectBtns_btn_pressed(btn_num:int):
	print(btn_num)


func _on_LeftModBtns_btn_pressed(btn_num:int):
	print(btn_num)


func _on_RightModBtns_btn_pressed(btn_num:int):
	print(btn_num)
