class_name Drone
extends "res://lifeforms/generic_lifeform.gd"

onready var traveled_line:Line2D = $StaticLineController/TraveledPath

var bounce_count:int = 0


func _ready():
	GroupMan.add_to_groups(self, ["DRONE", "PLAYER"])

#	yield(get_tree().create_timer(5), "timeout")
#	queue_free()


func enable():
	$CollisionShape2D.set_deferred("disabled", false)
	velocity = Vector2(cos(rotation), sin(rotation)) * speed

func disable():
	$CollisionShape2D.set_deferred("disabled", true)
	
	var curr_rot = global_rotation_degrees
	velocity = Vector2.ZERO
	set_deferred("global_rotation_degrees", curr_rot)


func init(start_pos:Vector2, start_rot:float):
	global_position = start_pos
	rotation = start_rot
	velocity = Vector2(cos(rotation), sin(rotation)) * speed
	traveled_line.add_point(start_pos)


# Drones bounce off of objects and change their heading
func handle_collision(collision:KinematicCollision2D):
	bounce_count += 1
	
	if collision.collider.is_in_group("HUB"):
		collision.collider.collect_drone(self)
	
	
	velocity = velocity.bounce(collision.normal)
	rotation_degrees = rad2deg(velocity.angle())
	traveled_line.add_point(global_position, 0)
