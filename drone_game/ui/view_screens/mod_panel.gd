extends Control

onready var equipped_grid := $ContentContainer/HBoxContainer/EquippedMods
onready var available_grid := $ContentContainer/HBoxContainer/AvailableMods


# Creates a new mod_mirror
func add_available_mod(new_mod):
	available_grid.add_child(new_mod)
	var _ok = new_mod.connect("relay_btn_pressed", self, "change_mod_equip_state")


# Populates the equipped_grid with drone's equipped mods
func add_equipped_from_drone(drone:Drone):
	print(drone.equipped_mods)


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


# Moves a mod from equipped to available
func unequip_mod(mod):
	mod.get_parent().remove_child(mod)
	available_grid.add_child(mod)
