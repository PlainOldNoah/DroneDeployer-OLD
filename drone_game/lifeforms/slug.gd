extends "res://lifeforms/generic_lifeform.gd"


func _ready():
	GroupMan.add_to_groups(self, ["SLUG", "ENEMY"])
	yield(get_tree().create_timer(5), "timeout")
	queue_free()


func init(pos:Vector2):
	global_position = pos
	set_vel_to_hub()


# Different behavior for hitting drone or the hub
func handle_collision(collision:KinematicCollision2D):
	if collision.collider.is_in_group("HUB"):
		queue_free()
#	elif collision.collider.is_in_group("DRONE"):
#		set_vel_to_hub()
#	else:
#		pass
#		print("ERROR")

func set_vel_to_hub():
	velocity = (Global.hub_scene.position - self.position).normalized() * speed
