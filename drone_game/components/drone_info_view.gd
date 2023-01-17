extends MarginContainer

onready var name_label:Label = get_node("%NameValue")
onready var battery_label:Label = get_node("%BatteryValue")
onready var battery_drain_label:Label = get_node("%BatteryDrainValue")
onready var speed_label:Label = get_node("%SpeedValue")
onready var damage_label:Label = get_node("%DamageValue")
onready var crit_chance_label:Label = get_node("%CritChanceValue")
onready var crit_damage_label:Label = get_node("%CritDamageValue")
onready var max_bounce_label:Label = get_node("%MaxBounceValue")

var linked_drone:Drone = null


# Sets the linked to d and updates the stat labels
func display_new_drone(d:Drone):
	if d == null:
		reset()
		return
	
	linked_drone = d
	
	if linked_drone.is_connected("stats_updated", self, "_on_drone_stats_changed"):
		linked_drone.disconnect("stats_updated", self, "_on_drone_stats_changed")
	var _ok := linked_drone.connect("stats_updated", self, "_on_drone_stats_changed")
	
	update_all_stat_labels(d)


# Sets all labels to default values
func reset():
	linked_drone = null
	
	name_label.text = ""
	battery_label.text = ""
	battery_drain_label.text = ""
	speed_label.text = ""
	damage_label.text = ""
	crit_chance_label.text = ""
	crit_damage_label.text = ""
	max_bounce_label.text = ""


func disconnect_previous_linked():
	if linked_drone.is_connected("stats_updated", self, "_on_drone_stats_changed"):
		linked_drone.disconnect("stats_updated", self, "_on_drone_stats_changed")


# Signal recived if a drones stat's change
# Only changes the targeted stat unless stat parm is left blank
func _on_drone_stats_changed(d:Drone, stat:String=""):
	if d == linked_drone:
		match stat:
			"display_name":
				name_label.text = d.display_name
#				print(d.stats.display_name, ", ", d.name)
			"battery", "max_battery":
				battery_label.text = "%d/%d" % [d.battery, d.stats.max_battery]
			"battery_drain":
				battery_drain_label.text = "%d/s" % d.stats.battery_drain
			"speed":
				speed_label.text = str(d.stats.speed)
			"damage":
				damage_label.text = str(d.stats.damage)
			"crit_chance":
				crit_chance_label.text = str(d.stats.crit_chance) + "%"
			"crit_dmg_mult":
				crit_damage_label.text = str(d.stats.crit_dmg_mult)
			"bounce":
				max_bounce_label.text = str(d.stats.bounce)
			_:
				update_all_stat_labels(d)


# Sets all the labels to match that of the drone's stats
func update_all_stat_labels(d:Drone):
	name_label.text = d.display_name
	battery_label.text = "%d/%d" % [d.battery, d.stats.max_battery]
	battery_drain_label.text = "%d/s" % d.stats.battery_drain
	speed_label.text = str(d.stats.speed)
	damage_label.text = str(d.stats.damage)
	crit_chance_label.text = str(d.stats.crit_chance) + "%"
	crit_damage_label.text = str(d.stats.crit_dmg_mult)
	max_bounce_label.text = str(d.stats.bounce)
