extends MarginContainer

onready var name_label:Label = get_node("%NameLabel")
onready var battery_label:Label = get_node("%BatteryLabel")
onready var speed_label:Label = get_node("%SpeedLabel")
onready var damage_label:Label = get_node("%DamageLabel")
onready var pickup_label:Label = get_node("%PickupLabel")
onready var crit_chance_label:Label = get_node("%CritChanceLabel")
onready var crit_damage_label:Label = get_node("%CritDamageLabel")
onready var max_bounce_label:Label = get_node("%MaxBounceLabel")


func _ready():
	yield(get_tree().root, "ready")
	var _ok = Global.game_manager.connect("drone_order_changed", self, "display_new_drone")


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
	name_label.text = "Name: " + value

func update_battery(value:int=0):
	battery_label.text = "Battery: " + str(value)

func update_speed(value:int=0):
	speed_label.text = "Speed: " + str(value)

func update_damage(value:int=0):
	damage_label.text = "Damage: " + str(value)

func update_pickup(value:int=0):
	pickup_label.text = "Pickup Range: " + str(value)

func update_crit_chance(value:int=0):
	crit_chance_label.text = "Crit Chance: " + str(value) + "%"

func update_crit_damage(value:int=0):
	crit_damage_label.text = "Crit Damage: " + str(value)

func update_max_bounce(value:int=0):
	max_bounce_label.text = "Max Bounces: " + str(value)
