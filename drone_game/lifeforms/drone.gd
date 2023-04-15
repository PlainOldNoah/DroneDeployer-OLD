class_name Drone
extends CharacterBody2D

signal stats_updated() #stats_updated(self, stat)

enum STATES {ACTIVE, IDLE, SPAWNING, STOPPED}
var state:int = STATES.IDLE

@onready var pickup_range := $PickupRange/CollisionShape2D

const DEFAULT_DRONE_STATS:Dictionary = {
	"max_battery":100, # Maximum battery level
	"battery_drain":5, # How much battery is lost per second while active
	"speed":300, # How fast drone moves
	"damage":1, # Attack damage against enemies
	"crit_chance":0, # Percentage chance of dealing a critical hit
	"crit_dmg_mult":1, # Normal damage multiplier when dealing crit hit
	"bounce":100, # How many bounces drone can make before going home
	}

var stats:Dictionary = {}
var battery:float = 0.0 # Current battery level
var display_name:String = "Drone"
var exp_held:int = 0
var bounce_count:int = 0
var battery_return_threshold:float = 0.50 #As a percentage

var equipped_mods:Array = [] # {"stat":affected_stat, "value":value}


func _ready():
	Global.add_to_groups(self, ["DRONE", "PLAYER"])
	
	display_name = "Drone_" + str(self.get_index())
	reset()
	
	modulate = Color(randf(), randf(), randf())


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func _process(delta):
	battery_calculation(delta)


# Sets the current position and rotation before enabling
func init(start_pos:Vector2, start_rot:float):
	global_position = start_pos
	rotation = start_rot
	bounce_count = 0
	set_state(STATES.SPAWNING)


# Reverts drone to default state
func reset():
	set_state(STATES.IDLE)
	calculate_stats()
	battery = stats.max_battery
	bounce_count = 0
	exp_held = 0


# State machine controller
# Active drones are currently in play while idle are waiting for deployment
# Spawning state uses spawn protection to prevent drones from instantly being collected
# IDLE -> SPAWNING -> ACTIVE -> STOPPED OR IDLE, STOPPED -> ACTIVE
func set_state(new_state:int):
	state = new_state
	match state:
		STATES.ACTIVE:
			show()
			set_process(true)
			set_physics_process(true)
			toggle_pickup_area(true)
			start_moving()
		STATES.IDLE:
			hide()
			set_process(true)
			set_physics_process(false)
			toggle_pickup_area(false)
			stop_moving()
		STATES.SPAWNING: # See HUB for SPAWNING -> ACTIVE
			show()
			set_process(true)
			set_physics_process(true)
			toggle_pickup_area(true)
			start_moving()
		STATES.STOPPED:
			stop_moving()
			toggle_pickup_area(false)
		_:
			print_debug("ERROR: <", state, "> is not a valid state")


# Saves the current rotation and sets speed to 0
func stop_moving():
	var stored_rotation = global_rotation_degrees
	set_velocity_and_rot(velocity, 0)
	set_deferred("global_rotation_degrees", stored_rotation)


# Resumes movement in current rotation direction
func start_moving():
	set_velocity_from_angle(rotation, stats.speed)


# Applies each enhancements bonus to the default stats to get new stats
func calculate_stats():
	stats = DEFAULT_DRONE_STATS.duplicate()
	for mod in equipped_mods:
		if (stats.has(mod.stat)):
			stats[mod.stat] += mod.value
		else:
			print_debug("ERROR: ", mod.stat, " does not exisit within drone")
	
	set_process(true)
	if battery > stats.max_battery:
		battery = stats.max_battery
	
	emit_signal("stats_updated", self) # Update all stats


# Controller for when the drone bumps into something
func handle_collision(collision:KinematicCollision2D):
	bounce_count += 1
	
	var collider:Node = collision.get_collider()
		
	if collider.is_in_group("ENEMY"):
		if collider.health > stats.damage:
			set_velocity_and_rot(get_bounce_direction(collision))
		collider.take_hit(stats.damage)
		
	elif collider.is_in_group("DRONE"):
		# Note: This seems to stops drones from doing several collisions at once
		set_velocity_and_rot(get_bounce_direction(collision))
		if collider.state == STATES.ACTIVE:
			collider.set_velocity_and_rot(get_bounce_direction(collision))
			collider.bounce_count += 1
	
	# If battery is below the threshold attempt to return home
	elif (battery/stats.max_battery) < battery_return_threshold:
		set_vel_to_hub()
	
	else:
		set_velocity_and_rot(get_bounce_direction(collision))
	
	# Deals with drones that hit slugs before escaping hub
	if bounce_count > 0 and state == STATES.SPAWNING:
		Global.hub_scene.collect_drone(self)
	
	if stats.bounce > 0 and bounce_count >= stats.bounce:
		set_vel_to_hub()
		
#	rotation_degrees = rad_to_deg(velocity.angle()) # Rotates drone to current heading


# Returns the direction of the bounce as a normalized vector
func get_bounce_direction(collision:KinematicCollision2D) -> Vector2:
	return velocity.bounce(collision.get_normal()).normalized()


# Decreases battery while active and charges while idle
func battery_calculation(delta:float):
	if state == STATES.ACTIVE: # Moving
		battery = clamp(battery - (stats.battery_drain * delta), 0.0, stats.max_battery)
	elif state == STATES.IDLE: # Idle
		battery = clamp(battery + (stats.battery_drain * 2 * delta), 0.0, stats.max_battery)
		
		if battery >= stats.max_battery: # Stop running function if battery is full
			set_process(false)
		
	emit_signal("stats_updated", self, "battery")
	
	if battery <= 0: # Battery == dead
		set_process(false)
		set_state(STATES.STOPPED)
#	elif (battery/stats.max_battery) <= battery_return_threshold:
#		print("Running Low: ", battery/stats.max_battery)


func set_velocity_and_rot(direction:Vector2, speed_override:float=stats.speed):
	set_velocity(direction * speed_override)
	rotation_degrees = rad_to_deg(velocity.angle())


# Set the velocity from an angle in degrees *  speed
func set_velocity_from_angle(degrees:float, speed_override:float=stats.speed):
	set_velocity_and_rot(Vector2(cos(degrees), sin(degrees)), speed_override)


# Sets the current heading to that of the HUB
func set_vel_to_hub():
	if state != STATES.STOPPED:
		set_velocity_and_rot((Global.hub_scene.global_position - self.global_position).normalized(), stats.speed)


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
func get_sprite() -> Texture2D:
	return $Sprite2D.texture


# Turns the pickup area on or off
func toggle_pickup_area(toggle:bool):
	set_deferred("pickup_range.disable", !toggle)


func _on_PickupRange_area_entered(area):
	area.toggle_attraction(true, self)


func _on_cleaning_range_area_entered(area):
	area.queue_free()
