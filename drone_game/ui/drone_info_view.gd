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


func display_new_drone(d:Drone):
	if d == null:
		reset()
		return
	
	linked_drone = d
	
	update_all_stat_labels(d)
#	update_name(d.custom_name)
#	update_battery(d.health)
#	update_speed(d.speed)
#	update_damage(d.damage)
#	update_crit_chance(d.crit_chance)
#	update_crit_damage(d.crit_damage_mod)
#	update_max_bounce(d.stats.bounce)


# Sets all labels to default values
func reset():
	linked_drone = null
#	update_name()
#	update_battery()
#	update_speed()
#	update_damage()
#	update_crit_chance()
#	update_crit_damage()
#	update_max_bounce()
	name_label.text = ""
	battery_label.text = ""
	battery_drain_label.text = ""
	speed_label.text = ""
	damage_label.text = ""
	crit_chance_label.text = ""
	crit_damage_label.text = ""
	max_bounce_label.text = ""


func _on_drone_stats_changed(d:Drone):
	if d == linked_drone:
		update_all_stat_labels(d)


#const DEFAULT_DRONE_STATS:Dictionary = {"max_battery":1, "battery":1, "speed":200, "damage":1, "crit_chance":0, "crit_dmg_mult":1, "bounce":1}
func update_all_stat_labels(d:Drone):
	name_label.text = d.stats.display_name
	battery_label.text = str(d.battery)
	battery_drain_label.text = str(d.stats.battery_drain)
	speed_label.text = str(d.stats.speed)
	damage_label.text = str(d.stats.damage)
	crit_chance_label.text = str(d.stats.crit_chance)
	crit_damage_label.text = str(d.stats.crit_dmg_mult)
	max_bounce_label.text = str(d.stats.bounce)


#func update_name(value:String=""):
#	name_label.text = value
#
#func update_battery(value:int=0):
#	battery_label.text = str(value)
#
#func update_battery_drain(value:int=0):
#	battery_drain_label.text = str(value)
#
#func update_speed(value:int=0):
#	speed_label.text = str(value)
#
#func update_damage(value:int=0):
#	damage_label.text = str(value)
#
#func update_crit_chance(value:int=0):
#	crit_chance_label.text = str(value) + "%"
#
#func update_crit_damage(value:int=0):
#	crit_damage_label.text = str(value)
#
#func update_max_bounce(value:int=0):
#	max_bounce_label.text = str(value)
