extends Control

@onready var drone_display := $MarginContainer/MainTrifold/DroneDisplay/DroneDisplay
@onready var drone_info_view := $MarginContainer/MainTrifold/SelectionDisplay/DroneInfoView
@onready var mod_panel := $MarginContainer/MainTrifold/AvailableModDisplay/HBoxContainer/ModPanel

var drone_mirror_path:String = "res://ui/components/drone_mirror.tscn"
var selected_drone:Drone = null


func _ready():
	Global.engr_menu = self
	await get_tree().root.ready
	
	var _ok = DroneManager.connect("drone_created",Callable(self,"add_drone_mirror"))
#	_ok = DroneManager.connect("drone_launched",Callable(self,"update_drone_display"))
#	_ok = DroneManager.connect("drone_added_to_queue",Callable(self,"update_drone_display"))
	_ok = ModManager.connect("enhancement_created",Callable(self,"add_new_available_mod"))


# Called when the GUI brings up this menu
func on_open():
	update_drone_display() # TODO: Stop this from being called every time


# Called when this menu is hidden by the GUI
func on_close():
	drone_selected(null)
	get_tree().call_group("POPUP", "toggle_popup", false)
	
#	for i in equipped_mods_view.get_children():
#		i.queue_free()
#	for i in available_mods_view.get_children():
#		i.toggle_popup(false)


# Creates a new drone_mirror and adds it to the drone_display
func add_drone_mirror(drone:Drone):
	var mirror_inst:Node = load(drone_mirror_path).instantiate()
	drone_display.add_item(mirror_inst)
	mirror_inst.init(80, true, true)
	mirror_inst.set_drone(drone)
	var _ok = mirror_inst.connect("relay_btn_pressed",Callable(self,"drone_selected"))


# Grays out currently deployed drones
func update_drone_display():
	for mirror in drone_display.get_items():
		match mirror.drone_ref.state:
			Drone.STATES.IDLE: # idle
				mirror.enable()
			_:
				mirror.disable()


# Handles updates required when selecting a new drone both here and in mod_panel
func drone_selected(d_mirror:DroneMirror):
	if is_instance_valid(d_mirror):
		selected_drone = d_mirror.drone_ref
		drone_info_view.display_new_drone(selected_drone)
		mod_panel.new_drone_selected(d_mirror.drone_ref)
	else:
		selected_drone = null
		mod_panel.clear_selected_drone()
		drone_info_view.reset()


# Bridge between mod_manager and mod_panel
func add_new_available_mod(mod_data:Dictionary):
	mod_panel.add_new_mod_display(mod_data, true)


func _on_EngineeringMenu_visibility_changed():
	if not is_instance_valid(mod_panel):
		return
	
	if visible:
		on_open()
	else:
		on_close()
