class_name Drone
extends "res://lifeforms/generic_lifeform.gd"

var bounce_count:int = 0


func _ready():
	GroupMan.add_to_groups(self, ["DRONE", "PLAYER"])

#	yield(get_tree().create_timer(5), "timeout")
#	queue_free()


func init(start_pos:Vector2, start_rot:float):
	global_position = start_pos
	rotation = start_rot
	velocity = Vector2(cos(rotation), sin(rotation)) * speed
	$StaticLineController/Line2D.add_point(start_pos)

# Drones bounce off of objects and change their heading
func handle_collision(collision:KinematicCollision2D):
	bounce_count += 1
#	print(self.name, " hit ", collision.collider.name)
	
	# IF/ELSE Statement
#	collision.collider.queue_free()
	
	velocity = velocity.bounce(collision.normal)
	rotation_degrees = rad2deg(velocity.angle())
	$StaticLineController/Line2D.add_point(global_position, 0)
