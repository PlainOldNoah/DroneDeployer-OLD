class_name Drone
extends KinematicBody2D

signal stats_updated() #stats_updated(self, stat)

enum STATES {ACTIVE, IDLE, SPAWNING, STOPPED}
var state:int = STATES.IDLE

onready var spawn_protection_timer := $SpawnProtectionTimer

var stats:Dictionary = {}
var velocity:Vector2 = Vector2.ZERO setget set_velocity
var battery:float = 0.0 # Current battery level
var bounce_count:int = 0
var exp_held:int = 0
var equipped_mods:Array = [] # {"stat":affected_stat, "value":value}


func _ready():
	GroupMan.add_to_groups(self, ["DRONE", "PLAYER"])
	
	calculate_stats()
	battery = stats.max_battery
	
	set_state(STATES.IDLE)
#	randomize_drone_stats() # WARNING


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


func set_state(new_state:int):
	state = new_state
	match state:
		STATES.ACTIVE:
			show()
			set_physics_process(true)
			set_process(true)
			start_moving()
		STATES.IDLE:
			hide()
			set_physics_process(false)
			set_process(true)
			stop_moving()
		STATES.SPAWNING:
			show()
			set_physics_process(true)
			start_moving()
			spawn_protection_timer.start()
		STATES.STOPPED:
			stop_moving()
		_:
			print_debug("ERROR: <", state, "> is not a valid state")


func stop_moving():
	var stored_rotation = global_rotation_degrees
#	set_velocity_from_angle(rotation, 0)
	set_velocity_from_vector(velocity, 0)
	set_deferred("global_rotation_degrees", stored_rotation)

func start_moving():
	set_velocity_from_angle(rotation, stats.speed)

# Set the velocity from an angle in degrees times the speed
func set_velocity_from_angle(degrees:float, speed_override:float=stats.speed):
	set_velocity(Vector2(cos(degrees), sin(degrees)) * speed_override)


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


func handle_collision(collision:KinematicCollision2D):
	bounce_count += 1
	
	var collider:Node = collision.collider
		
	if collider.is_in_group("ENEMY"):
		if collider.health > stats.damage:
			set_velocity_from_vector(get_bounce_direction(collision))
		collider.take_hit()
		
	elif collider.is_in_group("DRONE"):
		# Note: This seems to stops drones from doing several collisions at once
		set_velocity_from_vector(get_bounce_direction(collision))
		if collider.state == STATES.ACTIVE:
			collider.set_velocity_from_vector(get_bounce_direction(collision))
			collider.bounce_count += 1
			
	else:
		set_velocity_from_vector(get_bounce_direction(collision))

	if stats.bounce > 0 and bounce_count >= stats.bounce:
		set_vel_to_hub()


# Sets the current heading to that of the HUB
func set_vel_to_hub():
	if state != STATES.STOPPED:
		set_velocity((Global.hub_scene.global_position - self.global_position).normalized() * stats.speed)


# Set the velocity a normalized vector times the speed
func set_velocity_from_vector(direction:Vector2, speed_override:float=stats.speed):
	set_velocity(direction * speed_override)


# Returns the direction of the bounce as a normalized vector
func get_bounce_direction(collision:KinematicCollision2D) -> Vector2:
	return velocity.bounce(collision.normal).normalized()


func set_velocity(new_vel:Vector2):
	velocity = new_vel
	rotation_degrees = rad2deg(velocity.angle())


func battery_calculation(delta:float):
	if state == STATES.ACTIVE: # Moving
		battery = clamp(battery - (stats.battery_drain * delta), 0.0, stats.max_battery)
	elif state == STATES.IDLE: # Idle
		battery = clamp(battery + (stats.battery_drain * 2 * delta), 0.0, stats.max_battery)
	
	emit_signal("stats_updated", self, "battery")
	
	if battery <= 0: # Battery == dead
		set_process(false)
		set_state(STATES.STOPPED)
	elif battery >= stats.max_battery: # Battery == full
		set_process(false)


# Returns the sprite texture
func get_sprite() -> Texture:
	return $Sprite.texture


func _on_SpawnProtectionTimer_timeout():
	set_state(STATES.ACTIVE)
