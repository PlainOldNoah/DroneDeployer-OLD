extends Control

signal mirror_clicked()

@onready var drone_mirrors:Array = $ContentContainer/VBoxContainer.get_children()

var center_mirror:int = 0
var drone_list_ref:Array = []


func _ready():
	for i in drone_mirrors:
		i.init(32, true, true)
	center_mirror = ceil(drone_mirrors.size() / 2.0)
	drone_list_ref = DroneManager.full_drone_list


# Sets all the drone mirror to refernce the first drone in the lineup
func initialize():
	var d_list_pivot:int = 0
	var d_count:int = drone_list_ref.size()
	
	drone_mirrors[0].set_drone_with_state(drone_list_ref[fmod((d_list_pivot - 4), -d_count)])
	drone_mirrors[1].set_drone_with_state(drone_list_ref[fmod((d_list_pivot - 3), -d_count)])
	drone_mirrors[2].set_drone_with_state(drone_list_ref[fmod((d_list_pivot - 2), -d_count)])
	drone_mirrors[3].set_drone_with_state(drone_list_ref[fmod((d_list_pivot - 1), -d_count)])
	
	drone_mirrors[4].set_drone_with_state(drone_list_ref[d_list_pivot])
	
	drone_mirrors[5].set_drone_with_state(drone_list_ref[fmod(d_list_pivot + 1, d_count)])
	drone_mirrors[6].set_drone_with_state(drone_list_ref[fmod(d_list_pivot + 2, d_count)])
	drone_mirrors[7].set_drone_with_state(drone_list_ref[fmod(d_list_pivot + 3, d_count)])
	drone_mirrors[8].set_drone_with_state(drone_list_ref[fmod(d_list_pivot + 4, d_count)])


# Condenses all drone mirror buttons into one place
func _on_DroneMirror_relay_btn_pressed(caller:Node):
	emit_signal("mirror_clicked", caller)
