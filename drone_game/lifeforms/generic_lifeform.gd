extends CharacterBody2D

signal died()

enum STATES {SPAWNING, ACTIVE, PAUSED, DEAD}
@export var state: STATES = STATES.SPAWNING

@onready var immune_timer:Timer = $ImmunityTimer
@onready var death_sfx := $DeathSound

#var custom_name:String = ""
var max_health:int
var health:int
var speed:float
var damage:int

#var velocity:Vector2 = Vector2.ZERO : set = set_velocity
var immune:bool = false


func _ready():
	var _ok = connect("died",Callable(Global.level_manager,"lifeform_died"))


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


# Initializes enemy with stats
func set_stats(health_value:int = 1, speed_value:int = 100, damage_value:int = 1):
	max_health = health_value
	health = max_health
	speed = speed_value
	damage = damage_value


# State machine
func set_state(new_state:STATES):
	state = new_state
	match state:
		STATES.SPAWNING:
			pass
		STATES.ACTIVE:
			set_velocity_from_angle(rotation, speed)
		STATES.PAUSED:
			set_velocity_from_angle(rotation, 0)
		STATES.DEAD:
			death_sfx.play()
			visible = false
			$CollisionShape2D.disabled = true
			emit_signal("died", self)
			await death_sfx.finished
			queue_free()
		_:
			print_debug("ERROR: <", state, "> is not a valid state")


# Generic func for collisions, override in children
func handle_collision(collision:KinematicCollision2D):
	print_debug("ERROR: ", collision, " was not handled by ", name)


# Reduces health damage
func take_hit(dmg_amount:int=1):
	if not immune:
		set_health(health - dmg_amount)
		immune = true
		immune_timer.start()
		set_state(STATES.PAUSED)


# Sets the health to the new value
func set_health(value:int):
	health = clamp(value, 0, max_health)
	if health == 0:
		set_state(STATES.DEAD)


# Changes the velocity to the parameterized value
#func set_velocity(value:Vector2):
#	velocity = value


# Set the velocity from an angle in degrees times the speed
func set_velocity_from_angle(degrees:float, speed_override:float=speed):
	set_velocity(Vector2(cos(degrees), sin(degrees)) * speed_override)


# Sets the velocity to aim at a specified node
func set_target_destination(target:Node):
	if not is_instance_valid(target):
		print("<", target, "> is not a valid target for ", self)
	if state != STATES.PAUSED:
		var direction = (target.global_position - self.global_position).normalized()
		set_velocity(direction * speed)
		
		if sign(direction.x) == -1:
			$Sprite2D.set_flip_h(true)
		else:
			$Sprite2D.set_flip_h(false)


# Turns off immunity when timer is finished
func _on_ImmunityTimer_timeout():
	immune = false
	set_state(STATES.ACTIVE)
