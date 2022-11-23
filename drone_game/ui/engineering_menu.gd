extends Control

onready var drone_display:GridContainer = $MarginContainer/HBoxContainer/UIPanel/MarginContainer/DroneDisplay

var drone_mirror_path:String = "res://components/drone_mirror.tscn"

func _ready():
	yield(get_tree().root, "ready")
	var _ok = Global.drone_manager.connect("drone_created", self, "add_drone_mirror")
	_ok = null # Connect to fabricator(?) to get crafted upgrades & enhancements
	update_drone_display()


func add_drone_mirror(drone:Drone):
	var drone_mirror = load(drone_mirror_path).instance()
	drone_mirror.init(drone)
	drone_display.add_child(drone_mirror)
	drone_mirror.set_rect_size(100)


func update_drone_display():
	for mirror in drone_display.get_children():
		print(mirror.drone_ref.state)
	yield(get_tree().create_timer(0.5), "timeout")
	update_drone_display()


# Show the stats of the drone currently in the workbench
func update_drone_stats():
	pass


# Populate the equipped mods box with the selected drones equipped mods
func update_equipped_mods():
	pass
