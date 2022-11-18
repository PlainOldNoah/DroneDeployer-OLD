extends MarginContainer

onready var name_label:Label = get_node("%NameValue")
onready var battery_label:Label = get_node("%BatteryValue")
onready var speed_label:Label = get_node("%SpeedValue")
onready var damage_label:Label = get_node("%DamageValue")
onready var pickup_label:Label = get_node("%PickupValue")
onready var crit_chance_label:Label = get_node("%CritChanceValue")
onready var crit_damage_label:Label = get_node("%CritDamageValue")
onready var max_bounce_label:Label = get_node("%MaxBounceValue")


func _ready():
	yield(get_tree().root, "ready")
	var _ok = Global.drone_manager.connect("drone_queue_changed", self, "display_new_drone")


# Gets the first drone in the game manager's array and displays it's info
func display_new_drone(d:Drone):
	if d == null:
		reset()
		return
	
	update_name(d.custom_name)
	update_battery(d.health)
	update_speed(d.speed)
	update_damage(d.damage)
	update_pickup(d.pickup_range)
	update_crit_chance(d.crit_chance)
	update_crit_damage(d.crit_damage_mod)
	update_max_bounce(d.max_bounce_to_home)


# Sets all labels to default values
func reset():
	update_name()
	update_battery()
	update_speed()
	update_damage()
	update_pickup()
	update_crit_chance()
	update_crit_damage()
	update_max_bounce()


func update_name(value:String=""):
	name_label.text = value

func update_battery(value:int=0):
	battery_label.text = str(value)

func update_speed(value:int=0):
	speed_label.text = str(value)

func update_damage(value:int=0):
	damage_label.text = str(value)

func update_pickup(value:int=0):
	pickup_label.text = str(value)

func update_crit_chance(value:int=0):
	crit_chance_label.text = str(value) + "%"

func update_crit_damage(value:int=0):
	crit_damage_label.text = str(value)

func update_max_bounce(value:int=0):
	max_bounce_label.text = str(value)
