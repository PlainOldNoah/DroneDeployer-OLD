class_name Drone
extends "res://lifeforms/generic_lifeform.gd"

onready var tween = get_node("Tween")
var speed:int = 100

func _ready():
#	move()
	yield(get_tree().create_timer(5), "timeout")
	queue_free()


func _physics_process(delta):
	global_position += Vector2(cos(rotation), sin(rotation)) * speed * delta


#func move():
#	tween.interpolate_property(self, "global_position", self.global_position, get_global_mouse_position(), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
