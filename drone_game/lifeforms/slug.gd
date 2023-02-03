extends "res://lifeforms/generic_lifeform.gd"



func _ready():
	Global.add_to_groups(self, ["SLUG", "ENEMY"])


# OVERRIDE to have slugs follow the HUB should it happen to move
func _physics_process(delta):
	set_target_destination(Global.hub_scene)
	._physics_process(delta)


#func init(pos:Vector2):
#	global_position = pos
#	print(pos)
#	set_target_destination(Global.hub_scene)


# OVERRIDE: Flips the sprite, then calls parent function
#func set_velocity(value:Vector2):
#	if value.x > 0:
#		animation_player.play("faceRight")
#
#	else:
#		animation_player.play("faceLeft")
#	.set_velocity(value)


# OVERRIDE Different behavior for hitting drone or the hub
func handle_collision(collision:KinematicCollision2D):
	if collision.collider.is_in_group("HUB"):
		queue_free()
