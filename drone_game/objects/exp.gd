extends Area2D

export var value:int = 1
export var attract_force:int = 80
var target_body:Node = null
var acceleration:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO


func _ready():
	Global.add_to_groups(self, ["EXP"])
	set_physics_process(false)


# Simulating magnetic attraction
func _physics_process(delta):
	acceleration = Vector2()
	var dir = (target_body.position - position).normalized()
	acceleration += dir * attract_force

	velocity += acceleration * delta
	position += velocity


# Moves to the paramaterized body
func toggle_attraction(state, body):
	set_physics_process(state)
	target_body = body


# When a drone overlaps layers with self exp is picked up
func _on_Exp_body_entered(body):
#	print("Body Entered: ", body.name)
	if body.is_in_group("DRONE"):
		body.exp_held += value
		print_debug("Absorbed By: ", body.name)
		queue_free()
