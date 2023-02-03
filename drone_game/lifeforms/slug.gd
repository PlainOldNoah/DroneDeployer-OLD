extends "res://lifeforms/generic_lifeform.gd"



func _ready():
	Global.add_to_groups(self, ["SLUG", "ENEMY"])


# OVERRIDE to have slugs follow the HUB should it happen to move
func _physics_process(delta):
	set_target_destination(Global.hub_scene)
	._physics_process(delta)


# OVERRIDE Different behavior for hitting drone or the hub
func handle_collision(collision:KinematicCollision2D):
	if collision.collider.is_in_group("HUB"):
		queue_free()
