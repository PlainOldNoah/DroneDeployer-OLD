extends "res://lifeforms/generic_lifeform.gd"

signal died()

export var max_health:int = 3
var health:int = max_health setget set_health

onready var immune_timer:Timer = $ImmunityTimer
var immune:bool = false

func _ready():
	GroupMan.add_to_groups(self, ["SLUG", "ENEMY"])
	connect("died", get_parent(), "lifeform_died")


func init(pos:Vector2):
	global_position = pos
	set_vel_to_hub()


# Sets the health to the new value
func set_health(value:int):
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("died", self)
		queue_free()


# Reduces health damage
func take_hit(damage:int=1):
	if not immune:
		set_health(health - damage)
		immune = true
		immune_timer.start()
		stop()


# OVERRIDE Different behavior for hitting drone or the hub
func handle_collision(collision:KinematicCollision2D):
	if collision.collider.is_in_group("HUB"):
		queue_free()


# Turns off immunity when timer is finished
func _on_ImmunityTimer_timeout():
	immune = false
	set_vel_to_hub()
