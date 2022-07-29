class_name Drone
extends "res://lifeforms/generic_lifeform.gd"

onready var tween = get_node("Tween")
var speed:float = 100.0
var velocity:Vector2 = Vector2.ZERO
var bounce_count:int = 0

#func _ready():
#	yield(get_tree().create_timer(5), "timeout")
#	queue_free()


func init(start_pos:Vector2, start_rot:float):
	global_position = start_pos
	rotation = start_rot
	velocity = Vector2(cos(rotation), sin(rotation)) * speed


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision : KinematicCollision2D):
	bounce_count += 1
	velocity = velocity.bounce(collision.normal)
	rotation_degrees = rad2deg(velocity.angle())
