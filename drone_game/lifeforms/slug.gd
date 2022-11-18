extends "res://lifeforms/generic_lifeform.gd"

onready var immune_timer:Timer = $ImmunityTimer
var immune:bool = false


func _ready():
	GroupMan.add_to_groups(self, ["SLUG", "ENEMY"])


# OVERRIDE to have slugs follow the HUB should it happen to move
func _physics_process(delta):
	set_vel_to_hub()
	._physics_process(delta)


func init(pos:Vector2):
	global_position = pos
	set_vel_to_hub()


# OVERRIDE: Flips the sprite, then calls parent function
func set_velocity(value:Vector2):
	if value.x != 0:
		$Sprite.flip_h = (value.x < 0)
	.set_velocity(value)


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
	start()
