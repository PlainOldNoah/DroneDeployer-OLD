class_name Hub
extends StaticBody2D

onready var yellow_arrow:Sprite = $YellowArrow
onready var deploy_point = $YellowArrow/DeployPoint
onready var deploy_cooldown:Timer = $DeployCooldown

onready var ray:RayCast2D = $YellowArrow/RayCast2D
onready var trajectory:Line2D = $YellowArrow/Line2D
onready var test_ray:RayCast2D = $YellowArrow/RayCast2D2

var drone = preload("res://lifeforms/drone.tscn")
var can_deploy:bool = true


func _ready():
	Global.hub_scene = self
	GroupMan.add_to_groups(self, ["HUB"])
	
	trajectory.add_point(Vector2(0,0))
	trajectory.add_point(Vector2(0,0))
	ray.cast_to.x = 600#OS.window_size.x / 2


func _input(event):
	if event.is_action("deploy") and can_deploy:
		can_deploy = false
		spawn_drone()
		deploy_cooldown.start()


func _process(_delta):
	rotate_arrow()
	emit_ray()


# Rotate the deployment arrow to look at the cursor
func rotate_arrow():
	yellow_arrow.look_at(get_global_mouse_position())
	if Input.is_action_pressed("deploy_snap"):
		yellow_arrow.rotation_degrees = stepify(yellow_arrow.rotation_degrees, 45)


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
#	print(body, ": ", body.bounce_count)
	if body.bounce_count > 0:
		body.queue_free()

onready var trajectory_pt:Position2D = $YellowArrow/Trajectory_1
# Creates a line from the arrow to a collider
func emit_ray():
	if ray.is_colliding():
		trajectory_pt.global_position = ray.get_collision_point()
		trajectory.set_point_position(1, trajectory_pt.position - yellow_arrow.offset)
#		$YellowArrow/RayCast2D2.global_position = ray.get_collision_point()
#		$YellowArrow/RayCast2D2.cast_to = ray.cast_to.bounce($YellowArrow/RayCast2D2.get_collision_normal())
		
