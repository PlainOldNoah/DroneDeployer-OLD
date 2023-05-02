extends Control

@onready var prog_bar := $TextureProgressBar

var linked_drone:Drone = null

func _ready():
	var _ok = DroneManager.connect("drone_queue_updated", _on_linked_drone_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = get_global_mouse_position()


func _on_linked_drone_changed():
	if linked_drone != null and linked_drone.is_connected("stats_updated",_on_stats_updated):
		linked_drone.disconnect("stats_updated", _on_stats_updated)
	linked_drone = DroneManager.get_drone_from_queue(0)
	if linked_drone == null:
		prog_bar.hide()
	else:
		prog_bar.show()
		var _ok = linked_drone.connect("stats_updated", _on_stats_updated)


func _on_stats_updated(d:Drone, stat:String):
	if d == linked_drone:
		match stat:
			"max_battery":
				prog_bar.max_value = linked_drone.stats.max_battery
			"battery":
				prog_bar.value = linked_drone.battery

#func _on_drone_stats_changed(d:Drone, stat:String=""):
#	if d == linked_drone:
#		match stat:
#			"display_name":
#				name_label.text = d.display_name
##				print(d.stats.display_name, ", ", d.name)
#			"battery", "max_battery":
#				battery_label.text = "%d/%d" % [d.battery, d.stats.max_battery]
#			"battery_drain":
#				battery_drain_label.text = "%d/s" % d.stats.battery_drain
#			"speed":
#				speed_label.text = str(d.stats.speed)
#			"damage":
#				damage_label.text = str(d.stats.damage)
#			"crit_chance":
#				crit_chance_label.text = str(d.stats.crit_chance) + "%"
#			"crit_dmg_mult":
#				crit_damage_label.text = str(d.stats.crit_dmg_mult)
#			"bounce":
#				max_bounce_label.text = str(d.stats.bounce)
#			_:
#				update_all_stat_labels(d)


func display_cursor(value:bool):
	if value:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
