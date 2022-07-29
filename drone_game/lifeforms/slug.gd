extends "res://lifeforms/generic_lifeform.gd"


func _ready():
	GroupMan.add_to_groups(self, ["SLUG", "ENEMY"])
	set_vel_to_hub()
	

# Different behavior for hitting drone or the hub
func handle_collision(collision:KinematicCollision2D):
	if collision.collider.is_in_group("HUB"):
		queue_free()
	elif collision.collider.is_in_group("DRONE"):
		set_vel_to_hub()
	else:
		print("ERROR")


func set_vel_to_hub():
	velocity = self.global_position.direction_to(Global.hub_scene.global_position) * speed
