extends Control

onready var drone_display:GridContainer = $MarginContainer/HBoxContainer/UIPanel/MarginContainer/DroneDisplay

var drone_mirror_path:String = "res://components/drone_mirror.tscn"

func _ready():
	yield(get_tree().root, "ready")
	
	var _ok = Global.drone_manager.connect("drone_created", self, "add_drone_mirror")
	_ok = Global.drone_manager.connect("drone_launched", self, "update_drone_display")
	_ok = Global.drone_manager.connect("drone_added_to_queue", self, "update_drone_display")


# Creates a new drone mirror and adds it to the drone display
func add_drone_mirror(drone:Drone):
	var drone_mirror = load(drone_mirror_path).instance()
	drone_mirror.init(drone)
	drone_display.add_child(drone_mirror)
	drone_mirror.set_rect_size(100) # TODO: Make sure this isn't hardcoded


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


# Show the stats of the drone currently in the workbench
func update_drone_stats():
	pass


# Populate the equipped mods box with the selected drones equipped mods
func update_equipped_mods():
	pass
