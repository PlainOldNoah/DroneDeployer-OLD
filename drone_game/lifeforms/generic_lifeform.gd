extends KinematicBody2D

enum STATES {SPAWNING, MOVING, STOPPED, IDLE, DEAD}
export(STATES) var state = STATES.SPAWNING

export var custom_name:String = ""
export var damage:int = 1
export var max_health:int = 1
export var speed:float = 100.0

var velocity:Vector2 = Vector2.ZERO setget set_velocity
onready var health:int = max_health setget set_health


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision:KinematicCollision2D):
	print_debug("ERROR: ", collision, " was not handled by ", name)


# Sets the health to the new value
func set_health(value:int):
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("died", self)
		state = STATES.DEAD
		queue_free()


# Reduces health damage
func take_hit(value:int=1):
	pass


# Changes the velocity to the parameterized value
func set_velocity(value:Vector2):
	velocity = value


# Set the velocity a normalized vector times the speed
func set_velocity_from_vector(direction:Vector2, speed_override:float=speed):
	set_velocity(direction * speed_override)


# Set the velocity from an angle in degrees times the speed
func set_velocity_from_angle(degrees:float, speed_override:float=speed):
	set_velocity(Vector2(cos(degrees), sin(degrees)) * speed_override)


# Sets the velocity to the current rotation times speed
func start():
	set_velocity_from_angle(rotation, speed)
	state = STATES.MOVING


# Sets the current speed to 0 but maintains direction
func stop():
	set_velocity_from_angle(rotation, 0)
	state = STATES.STOPPED


# Sets the current heading to that of the HUB
func set_vel_to_hub():
	if state != STATES.STOPPED:
		set_velocity((Global.hub_scene.global_position - self.global_position).normalized() * speed)
