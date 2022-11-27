extends Control

#signal mirror_clicked()

onready var drone_display := $MarginContainer/HBoxContainer/UIPanel/MarginContainer/DroneDisplay
onready var selected_drone_mirror:DroneMirror = $MarginContainer/HBoxContainer/WorkArea/UIPanel2/MarginContainer/SelectedDrone/DroneMirror
onready var drone_info_view := $MarginContainer/HBoxContainer/WorkArea/DroneInfoView

var drone_mirror_path:String = "res://components/click_drone_mirror.tscn"
var selected_drone:Drone = null

func _ready():
	yield(get_tree().root, "ready")
	
	var _ok = Global.drone_manager.connect("drone_created", self, "add_drone_mirror")
	_ok = Global.drone_manager.connect("drone_launched", self, "update_drone_display")
	_ok = Global.drone_manager.connect("drone_added_to_queue", self, "update_drone_display")


# Called when the GUI brings up this menu
func on_open():
	pass


# Called when this menu is hidden by the GUI
func on_close():
	drone_info_view.reset()
	selected_drone_mirror.reset()
	selected_drone = null


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


# Show the stats of the drone currently in the workbench
func update_drone_stats():
	drone_info_view.display_new_drone(selected_drone)


# Populate the equipped mods box with the selected drones equipped mods
func update_equipped_mods():
	pass


func _on_EngineeringMenu_visibility_changed():
	if visible:
		on_open()
	else:
		on_close()
