extends KinematicBody2D

export var speed:float = 100.0
var velocity:Vector2 = Vector2.ZERO setget set_velocity
var prev_velocity:Vector2 = Vector2.ZERO


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(_collision:KinematicCollision2D):
	pass


func set_velocity(value:Vector2):
	velocity = value


func start():
	set_velocity(prev_velocity)
#	velocity = Vector2(cos(rotation), sin(rotation)) * speed


func stop():
	prev_velocity = velocity
	set_velocity(Vector2.ZERO)


# Sets the current heading to that of the HUB
func set_vel_to_hub():
	set_velocity((Global.hub_scene.global_position - self.global_position).normalized() * speed)
