class_name Drone
extends "res://lifeforms/generic_lifeform.gd"

onready var traveled_line:Line2D = $TraveledPath
onready var rng:RandomNumberGenerator = RandomNumberGenerator.new()

export var max_bounce_to_home:int = 0 # If 0 then ignore
export var pickup_range:int = 1
export var crit_chance:int = 0
export var crit_damage_mod:int = 1
export var show_path:bool = false

var bounce_count:int = 0
var exp_held:int = 0


func _ready():
	GroupMan.add_to_groups(self, ["DRONE", "PLAYER"])
	traveled_line.set_as_toplevel(true)
	z_index += 1
	disable()
	
	randomize_drone_stats()


func randomize_drone_stats():
	rng.randomize()
	custom_name = name
	health = rng.randi_range(1, 10)
	speed = rng.randi_range(250, 500)
	damage = rng.randi_range(1, 5)
	pickup_range = rng.randi_range(1, 3)
	crit_chance = rng.randi_range(0, 100)
	crit_damage_mod = rng.randi_range(1, 5)
	max_bounce_to_home = rng.randi_range(1, 5)
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
		if collider.health > 1:
			set_velocity_from_vector(get_bounce_direction(collision))
		collider.take_hit()
	else:
		set_velocity_from_vector(get_bounce_direction(collision))
	
	if show_path:
		traveled_line.add_point(global_position, 0)
	
	if max_bounce_to_home > 0 and bounce_count >= max_bounce_to_home:
		set_vel_to_hub()


# Returns the direction of the bounce as an angle in degrees
func get_bounce_angle(collision:KinematicCollision2D) -> float:
	return rad2deg(velocity.bounce(collision.normal).angle())


# Returns the direction of the bounce as a normalized vector
func get_bounce_direction(collision:KinematicCollision2D) -> Vector2:
	return velocity.bounce(collision.normal).normalized()


# Returns the sprite texture
func get_sprite() -> Texture:
	return $Sprite.texture
