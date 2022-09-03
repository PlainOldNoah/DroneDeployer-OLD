extends Area2D

export var value:int = 1

func _on_Exp_body_entered(body):
	if body.is_in_group("DRONE"):
		body.exp_held += value
		queue_free()
