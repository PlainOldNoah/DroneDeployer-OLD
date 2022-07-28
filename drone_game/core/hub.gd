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
	drone_inst.global_position = deploy_point.global_position # Spawn at the deploy point
	drone_inst.global_rotation = deploy_point.global_rotation


func _on_DeployCooldown_timeout():
	can_deploy = true
