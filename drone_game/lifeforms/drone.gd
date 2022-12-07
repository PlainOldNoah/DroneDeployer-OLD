class_name Drone
extends "res://lifeforms/generic_lifeform.gd"

signal stats_updated() #stats_updated(self, stat)

onready var battery_controller:Timer = $BatteryController
onready var traveled_line:Line2D = $TraveledPath
onready var rng:RandomNumberGenerator = RandomNumberGenerator.new()

export var show_path:bool = false

var stats:Dictionary = {}
var battery:float = 0.0 # Current battery level
var bounce_count:int = 0
var exp_held:int = 0
var equipped_mods:Array = [] # {"stat":affected_stat, "value":value}


func _ready():
	GroupMan.add_to_groups(self, ["DRONE", "PLAYER"])
	traveled_line.set_as_toplevel(true)
	disable()
	
	calculate_stats()
	battery = stats.max_battery
	randomize_drone_stats() # WARNING


func _process(delta):
	battery_calculation(delta)


# OVERRIDE: Setter function for state var
func set_state(new_state:int):
	# Turn process back on to (dis)charge battery
	if state == STATES.IDLE or state == STATES.MOVING:
		set_process(true)
		
	.set_state(new_state)


func battery_calculation(delta:float):
	if state == 1: # Moving
		battery = clamp(battery - (stats.battery_drain * delta), 0.0, stats.max_battery)
	elif state == 3: # Idle
		battery = clamp(battery + (stats.battery_drain * 2 * delta), 0.0, stats.max_battery)
	
	emit_signal("stats_updated", self, "battery")
	
	if battery <= 0:
		set_process(false)
		# Drone is dead in the water, can turn off function for now
	elif battery >= stats.max_battery:
		set_process(false)
		# Fully charaged, can turn off function for now


# Applies each enhancements bonus to the default stats to get new stats
func calculate_stats():
	stats = GameVars.DEFAULT_DRONE_STATS.duplicate()
	for mod in equipped_mods:
#		print(mod, " -> ", stats) # DEBUG
		if (stats.has(mod.stat)):
			stats[mod.stat] += mod.value
		else:
			print_debug("ERROR: ", mod.stat, " does not exisit within drone")
	
	set_process(true)
	if battery > stats.max_battery:
		battery = stats.max_battery
	
	emit_signal("stats_updated", self) # Update all stats


# DEBUG: This conflicts with the game_vars default stats
func randomize_drone_stats():
	rng.randomize()
	custom_name = name
#	health = rng.randi_range(1, 10)
#	speed = rng.randi_range(250, 500)
#	damage = rng.randi_range(1, 5)
#	pickup_range = rng.randi_range(1, 3)
#	crit_chance = rng.randi_range(0, 100)
#	crit_damage_mod = rng.randi_range(1, 5)
#	max_bounce_to_home = rng.randi_range(1, 5)
	modulate = Color(randf(), randf(), randf())


# Sets the current position and rotation before enabling
func init(start_pos:Vector2, start_rot:float):
	global_position = start_pos
	rotation = start_rot
	bounce_count = 0
	enable()


# OVERRIDE so drones correct their rotation
func set_velocity(value:Vector2):
	.set_velocity(value)
	rotation_degrees = rad2deg(velocity.angle())


# Removes all current points and then starts a new line
func restart_travel_path():
	traveled_line.clear_points()
	traveled_line.add_point(global_position)


# Turns collision on and starts movement
func enable():
	show()
	set_physics_process(true)
	restart_travel_path()
	start()


# Turns off drone's collision, movement, and traveled line
func disable():
	hide()
	stop()
	set_physics_process(false)
	traveled_line.clear_points()
	state = STATES.IDLE


# OVERRIDE Sets velocity to zero while mantaining rotation
func stop():
	var stored_rotation = global_rotation_degrees
	.stop()
	set_deferred("global_rotation_degrees", stored_rotation)


# OVERRIDE Drones bounce off of objects and change their heading
func handle_collision(collision:KinematicCollision2D):
	bounce_count += 1
	
	var collider:Node = collision.collider
	
	if collider.is_in_group("HUB"):
		collider.collect_drone(self)
	elif collider.is_in_group("ENEMY"):
		if collider.health > stats.damage:
			set_velocity_from_vector(get_bounce_direction(collision))
		collider.take_hit()
	else:
		set_velocity_from_vector(get_bounce_direction(collision))
	
	if show_path:
		traveled_line.add_point(global_position, 0)
	
	if stats.bounce > 0 and bounce_count >= stats.bounce:
		set_vel_to_hub()


# Returns the direction of the bounce as an angle in degrees
func get_bounce_angle(collision:KinematicCollision2D) -> float:
	return rad2deg(velocity.bounce(collision.normal).angle())


# Returns the direction of the bounce as a normalized vector
func get_bounce_direction(collision:KinematicCollision2D) -> Vector2:
	return velocity.bounce(collision.normal).normalized()


# Adds the mod to the equipped_mods array
func add_mod(mod:Dictionary):
	equipped_mods.append(mod)
	calculate_stats()


# Removes the mod from equipped_mods if it exists
func remove_mod(mod:Dictionary):
	if equipped_mods.has(mod):
		equipped_mods.erase(mod)
		calculate_stats()
	else:
		print_debug("ERROR: <", mod, "> could not be removed")


# Returns the sprite texture
func get_sprite() -> Texture:
	return $Sprite.texture
