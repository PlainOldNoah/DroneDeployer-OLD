extends Control

@onready var equipped_grid := $ContentContainer/HBoxContainer/EquippedMods
@onready var available_grid := $ContentContainer/HBoxContainer/AvailableMods

var selected_drone:Drone = null


func new_drone_selected(new_drone:Drone):
	selected_drone = new_drone
	add_equipped_from_drone(new_drone)


func clear_selected_drone():
	selected_drone = null
	clear_equipped_mod_display()


# Creates a new mod_mirror
# mod_data are the mod stats, available == true spawns the mod in available grid
func add_new_mod_display(mod_data:Dictionary, available:bool=true):
	var mod_display_inst = load("res://components/mod_display.tscn").instantiate()
	
	if available:
		available_grid.add_child(mod_display_inst)
	else:
		equipped_grid.add_child(mod_display_inst)
	
	mod_display_inst.init(mod_data)
	var _ok = mod_display_inst.connect("relay_btn_pressed",Callable(self,"change_mod_equip_state"))


# Populates the equipped_grid with drone's equipped mods
func add_equipped_from_drone(drone:Drone):
	clear_equipped_mod_display()
	
	for i in drone.equipped_mods.size():
		add_new_mod_display(drone.equipped_mods[i], false)


# Removes all mod displays from equipped_grid
func clear_equipped_mod_display():
	for i in equipped_grid.get_children():
		i.queue_free()


# Unequipped if equipped, equip if available
func change_mod_equip_state(mod:Node):
	var previous_parent:Node = mod.get_parent()
	
	if previous_parent == equipped_grid:
		unequip_mod(mod)
	elif previous_parent == available_grid:
		equip_mod(mod)


# Moves a mod from available to equipped
func equip_mod(mod):
	mod.get_parent().remove_child(mod)
	equipped_grid.add_child(mod)
	selected_drone.add_mod(mod.cached_mod)


# Moves a mod from equipped to available
func unequip_mod(mod):
	mod.get_parent().remove_child(mod)
	available_grid.add_child(mod)
	selected_drone.remove_mod(mod.cached_mod)
