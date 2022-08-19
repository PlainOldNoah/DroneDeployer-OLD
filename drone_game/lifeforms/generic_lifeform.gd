extends KinematicBody2D

export var speed:float = 100.0
var velocity:Vector2 = Vector2.ZERO


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision:KinematicCollision2D):
	pass
