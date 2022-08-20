class_name Drone
extends "res://lifeforms/generic_lifeform.gd"

onready var traveled_line:Line2D = $StaticLineController/TraveledPath

enum DRONE_STATES {MOVING, IDLE}
var state = DRONE_STATES.IDLE

var bounce_count:int = 0


func _ready():
	GroupMan.add_to_groups(self, ["DRONE", "PLAYER"])


# Sets the current position and rotation before enabling
func init(start_pos:Vector2, start_rot:float):
	global_position = start_pos
	rotation = start_rot
	enable()


# Removes all current points and then starts a new line
func restart_travel_path():
	traveled_line.clear_points()
	traveled_line.add_point(global_position)


# Turns collision on and starts movement
func enable():
	$CollisionShape2D.set_deferred("disabled", false)
	restart_travel_path()
	start()


# Turns off drone's collision, movement, and traveled line
func disable():
	$CollisionShape2D.set_deferred("disabled", true)
	traveled_line.clear_points()
	stop()


# Sets the drones velocity to moving
func start():
	state = DRONE_STATES.MOVING
	velocity = Vector2(cos(rotation), sin(rotation)) * speed


# Sets velocity to zero while mantaining rotation
func stop():
	state = DRONE_STATES.IDLE
	var curr_rot = global_rotation_degrees
	velocity = Vector2.ZERO
	set_deferred("global_rotation_degrees", curr_rot)


# Drones bounce off of objects and change their heading
func handle_collision(collision:KinematicCollision2D):
	bounce_count += 1
	
	if collision.collider.is_in_group("HUB"):
		collision.collider.collect_drone(self)
	
	velocity = velocity.bounce(collision.normal)
	rotation_degrees = rad2deg(velocity.angle())
	traveled_line.add_point(global_position, 0)
