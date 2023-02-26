extends Control

onready var drone_display := $MarginContainer/MainTrifold/DroneDisplay/DroneDisplay
onready var drone_info_view := $MarginContainer/MainTrifold/SelectionDisplay/DroneInfoView
onready var mod_panel := $MarginContainer/MainTrifold/AvailableModDisplay/HBoxContainer/ModPanel
#onready var equipped_mods_view := $MarginContainer/MainTrifold/SelectionDisplay/EquippedMods/EquippedMods
#onready var available_mods_view := $MarginContainer/MainTrifold/AvailableModDisplay/HBoxContainer/AvailableMods

var drone_mirror_path:String = "res://components/drone_mirror.tscn"
var mod_display_path:String = "res://components/mod_display.tscn"
var selected_drone:Drone = null


func _ready():
	Global.engr_menu = self
	yield(get_tree().root, "ready")
	
	var _ok = Global.drone_manager.connect("drone_created", self, "add_drone_mirror")
#	_ok = Global.drone_manager.connect("drone_launched", self, "update_drone_display")
#	_ok = Global.drone_manager.connect("drone_added_to_queue", self, "update_drone_display")
	_ok = Global.mod_manager.connect("enhancement_created", self, "add_free_enhancement")


# Called when the GUI brings up this menu
func on_open():
	update_drone_display() # TODO: Stop this from being called every time


# Called when this menu is hidden by the GUI
func on_close():
	drone_info_view.reset()
	selected_drone = null
#	for i in equipped_mods_view.get_children():
#		i.queue_free()
#	for i in available_mods_view.get_children():
#		i.toggle_popup(false)
	for i in drone_display.get_children():
		get_tree().call_group("POPUP", "toggle_popup", false)


# Creates a new drone_mirror and adds it to the drone_display
func add_drone_mirror(drone:Drone):
	var mirror_inst:Node = load(drone_mirror_path).instance()
	drone_display.add_child(mirror_inst)
	mirror_inst.init(80, true, true)
	mirror_inst.set_drone(drone)
	mirror_inst.connect("relay_btn_pressed", self, "drone_selected")


# Grays out currently deployed drones
func update_drone_display():
	for mirror in drone_display.get_children():
		match mirror.drone_ref.state:
			Drone.STATES.IDLE: # idle
				mirror.enable()
			_:
				mirror.disable()


# Sets the selected drone and calls related funcs to display needed info
func drone_selected(d_mirror:DroneMirror):
	selected_drone = d_mirror.drone_ref
	drone_info_view.display_new_drone(selected_drone)
	mod_panel.add_equipped_from_drone(d_mirror.drone_ref)


func add_available_mod():
	var mod_2_add = load("res://components/mod_display.tscn").instance()
	mod_panel.add_available_mod(mod_2_add)

# Populate the equipped mods box with the selected drones equipped mods
#func update_equipped_mods():
#	for i in equipped_mods_view.get_items():
#		i.queue_free()
#
#	for i in selected_drone.equipped_mods.size():
#		var mod_disp:Node = load(mod_display_path).instance()
#		equipped_mods_view.add_child(mod_disp)
#		mod_disp.init(selected_drone.equipped_mods[i])
#		var _ok = mod_disp.connect("relay_btn_pressed", self, "change_mod_equip_state")


# Called when a new enhancement is made and adds it to the 'free mods' window
#func add_free_enhancement(new_enhance:Dictionary):
#	var mod_disp:Node = load(mod_display_path).instance()
#	available_mods_view.add_child(mod_disp)
#	mod_disp.init(new_enhance)
#	var _ok = mod_disp.connect("relay_btn_pressed", self, "change_mod_equip_state")


# If mod is free, equip it. If mod is equipped, unequip it
#func change_mod_equip_state(mod:Node):
#	if selected_drone == null:
#		print_debug("No drone selected")
#		return
#
#	var previous_owner:Node = mod.get_owner()
#	mod.get_parent().remove_child(mod)
#	mod.toggle_popup(false) # Can do this in mod as it doesn't always transfer
#
#	if previous_owner == available_mods_view:
#		equipped_mods_view.add_child(mod)
#		equip_mod_onto_drone(mod.cached_mod)
#	elif previous_owner == equipped_mods_view:
#		available_mods_view.add_child(mod)
#		remove_mod_from_drone(mod.cached_mod)


# Adds the mod to the selected drones equipped_mod dictionary
func equip_mod_onto_drone(mod:Dictionary):
	selected_drone.add_mod(mod)


# Erases the mod from the selected drones equipped_mod dictionary
func remove_mod_from_drone(mod:Dictionary):
	selected_drone.remove_mod(mod)


#var drone_page:int = 0
#
## Sets the drone mirrors to groups of 9 drones
#func moveto_drone_page(page:int):
#	clear_drone_icons()
#	var mirrors:Array = drone_display.get_items()
#	var drone_list_ref:Array = Global.drone_manager.full_drone_list
#
#	drone_page = clamp(page, 0, drone_list_ref.size() / 9.0)
#	for i in 9: # One for each mirror
#		var focused:int = i + (9 * drone_page)
## Set each mirror with correct drone
#		if focused < drone_list_ref.size():
#			mirrors[i].set_drone(drone_list_ref[focused])
## Gray out currently deployed drones
#			match mirrors[i].drone_ref.state:
#				Drone.STATES.IDLE: # idle
#					mirrors[i].enable()
#				_:
#					mirrors[i].disable()
#
#
## Removes all drones from the drone mirrors
#func clear_drone_icons():
#	for i in drone_display.get_items():
#		i.reset()



func _on_EngineeringMenu_visibility_changed():
	if visible:
		on_open()
	else:
		on_close()
