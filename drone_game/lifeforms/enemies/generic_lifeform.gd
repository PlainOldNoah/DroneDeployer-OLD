extends CharacterBody2D

signal died()

enum STATES {SPAWNING, ACTIVE, PAUSED, DEAD}
var state: STATES = STATES.SPAWNING

const ENEMY_DATA = preload("res://lifeforms/enemies/enemy_data.gd")

@onready var death_sfx := $DeathSound
@onready var immune_timer:Timer = $ImmunityTimer

var stats:Dictionary = {}

var health:int
var immune:bool = false
var facing:int = 0


func _ready():
	pass


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


# Reads from ENEMY_DATA to init lifeform
func load_data(enemy_type:String):
	var data:Dictionary = ENEMY_DATA.enemy_data[enemy_type]
	stats = data.duplicate()
	$Sprite2D.set_texture(load(data.sprite_path))
	health = stats.max_health


# State machine
func set_state(new_state:STATES):
	state = new_state
	match state:
		STATES.SPAWNING:
			pass
		STATES.ACTIVE:
			set_velocity_from_angle(rotation, stats.speed)
		STATES.PAUSED:
			set_velocity_from_angle(rotation, 0)
		STATES.DEAD:
			_on_death()
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
		immune_timer.start(stats.stun_cooldown)
		set_state(STATES.PAUSED)


# Sets the health to the new value
func set_health(value:int):
	health = clamp(value, 0, stats.max_health)
	if health == 0:
		set_state(STATES.DEAD)


# Set the velocity from an angle in degrees times the speed
func set_velocity_from_angle(degrees:float, speed_override:float=stats.speed):
	set_velocity(Vector2(cos(degrees), sin(degrees)) * speed_override)


# Sets the velocity to aim at a specified node
func set_target_destination(target:Node):
	if not is_instance_valid(target):
		print("<", target, "> is not a valid target for ", self)
	if state != STATES.PAUSED:
		var direction = (target.global_position - self.global_position).normalized()
		set_velocity(direction * stats.speed)
		
		if sign(direction.x) != facing:
			facing = sign(direction.x)
			self.scale.x = (abs(self.scale.x) * sign(direction.x))


# What to do when lifeform dies
func _on_death():
	death_sfx.play()
	visible = false
	$CollisionShape2D.disabled = true
#	emit_signal("died", self)
	await death_sfx.finished
	
	queue_free()


# Create and add scrap/drops for dying
func spawn_drops():
	pass


# Turns off immunity when timer is finished
func _on_ImmunityTimer_timeout():
	immune = false
	set_state(STATES.ACTIVE)


func _on_gameboard_detector_area_entered(_area):
	pass # Replace with function body.
