extends Control

#signal mirror_clicked()

onready var drone_display := $MarginContainer/HBoxContainer/UIPanel/MarginContainer/DroneDisplay
onready var selected_drone_mirror:DroneMirror = $MarginContainer/HBoxContainer/WorkArea/UIPanel2/MarginContainer/SelectedDrone/DroneMirror
onready var drone_info_view := $MarginContainer/HBoxContainer/WorkArea/DroneInfoView
onready var available_mods_view := $MarginContainer/HBoxContainer/UIPanel2/MarginContainer/AvailableMods
onready var equipped_mods_view := $MarginContainer/HBoxContainer/WorkArea/UIPanel3/MarginContainer/EquippedMods

var drone_mirror_path:String = "res://components/click_drone_mirror.tscn"
var mod_display_path:String = "res://components/mod_display.tscn"

var selected_drone:Drone = null
var available_mods:Array = []


func _ready():
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
	drone_info_view.reset()
	selected_drone_mirror.reset()
	selected_drone = null
	for i in equipped_mods_view.get_children():
		i.queue_free()
	for i in available_mods_view.get_children():
		i.toggle_popup(false)


# Creates a new drone mirror and adds it to the drone display
func add_drone_mirror(drone:Drone):
	var drone_mirror = load(drone_mirror_path).instance()
	drone_mirror.init(drone)
	drone_display.add_child(drone_mirror)
	drone_mirror.set_rect_size(100) # TODO: Make sure this isn't hardcoded
	var _ok = drone_mirror.connect("relay_btn_pressed", self, "drone_selected")


# Grays out currently deployed drones
func update_drone_display(_drone:Drone):
	for mirror in drone_display.get_children():
		match mirror.drone_ref.state:
			1: # moving
				mirror.disable()
			3: # idle
				mirror.enable()
			_:
				print_debug("WARNING: Drone state <", mirror.drone_ref.state, "> not handled")


# Sets the selected drone and calls related funcs to display needed info
func drone_selected(d_mirror:DroneMirror):
	selected_drone = d_mirror.drone_ref
	selected_drone_mirror.init(selected_drone)
	update_drone_stats()
	update_equipped_mods()


# Show the stats of the drone currently in the workbench
func update_drone_stats():
	drone_info_view.display_new_drone(selected_drone)


# Populate the equipped mods box with the selected drones equipped mods
func update_equipped_mods():
	for i in equipped_mods_view.get_children():
		i.queue_free()
	
	for i in selected_drone.equipped_mods.size():
		var mod_disp:Node = load(mod_display_path).instance()
		equipped_mods_view.add_child(mod_disp)
		mod_disp.init(selected_drone.equipped_mods[i])
		var _ok = mod_disp.connect("relay_btn_pressed", self, "change_mod_equip_state")


# Called when a new enhancement is made and adds it to the 'free mods' window
func add_free_enhancement(new_enhance:Dictionary):
#	available_mods.append(new_enhance)
	var mod_disp:Node = load(mod_display_path).instance()
	available_mods_view.add_child(mod_disp)
	mod_disp.init(new_enhance)
	var _ok = mod_disp.connect("relay_btn_pressed", self, "change_mod_equip_state")


# If mod is free, equip it. If mod is equipped, unequip it
func change_mod_equip_state(mod:Node):
	if selected_drone == null:
		print_debug("No drone selected")
		return
	
	var old_parent:Node = mod.get_parent()
	old_parent.remove_child(mod)
	mod.toggle_popup(false) # Can do this in mod as it doesn't always transfer
	
	if old_parent == available_mods_view:
		equipped_mods_view.add_child(mod)
		equip_mod_onto_drone(mod.cached_mod)
	elif old_parent == equipped_mods_view:
		available_mods_view.add_child(mod)
		remove_mod_from_drone(mod.cached_mod)


# Adds the mod to the selected drones equipped_mod dictionary
func equip_mod_onto_drone(mod:Dictionary):
	selected_drone.add_mod(mod)
#	selected_drone.equipped_mods.append(mod)


# Erases the mod from the selected drones equipped_mod dictionary
func remove_mod_from_drone(mod:Dictionary):
	selected_drone.remove_mod(mod)
#	selected_drone.equipped_mods.erase(mod)


func _on_EngineeringMenu_visibility_changed():
	if visible:
		on_open()
	else:
		on_close()
