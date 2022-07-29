class_name Hub
extends StaticBody2D

onready var yellow_arrow:Sprite = $YellowArrow
onready var deploy_point = $YellowArrow/DeployPoint
onready var deploy_cooldown:Timer = $DeployCooldown

var drone = preload("res://lifeforms/drone.tscn")
var can_deploy:bool = true


func _input(event):
	if event is InputEventMouseButton and can_deploy:
		can_deploy = false
		spawn_drone()
		deploy_cooldown.start()


func _process(_delta):
	yellow_arrow.look_at(get_global_mouse_position()) # Rotate arrow


# Create a drone instance and set it's pos and rot to that of the arrow
func spawn_drone():
	var drone_inst:KinematicBody2D = drone.instance()
	self.add_child(drone_inst)
	drone_inst.init(deploy_point.global_position, deploy_point.global_rotation)


# Limits drone spamming
func _on_DeployCooldown_timeout():
	can_deploy = true


# Aura around the HUB that collects deployed drones
func _on_PickUpZone_body_entered(body):
	print(body, ": ", body.bounce_count)
	if body.bounce_count > 0:
		body.queue_free()
