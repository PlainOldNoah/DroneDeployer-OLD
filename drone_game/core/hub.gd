class_name Hub
extends StaticBody2D

signal exp_retrieved()

export var max_drones:int = 10

onready var yellow_arrow:Sprite = $YellowArrow
onready var deploy_point = $YellowArrow/DeployPoint
onready var deploy_cooldown:Timer = $DeployCooldown

onready var ray:RayCast2D = $YellowArrow/TrajectoryRay
onready var trajectory:Line2D = $YellowArrow/TrajectoryLine
onready var trajectory_pt:Position2D = $YellowArrow/TrajectoryPoint

var drone_scene = preload("res://lifeforms/drone.tscn")
var can_deploy:bool = true
#var current_exp:int = 0
var drone_list:Array


func _ready():
	yield(get_tree().root, "ready")
	Global.hub_scene = self
	GroupMan.add_to_groups(self, ["HUB"])
	
	trajectory.add_point(Vector2(0,0))
	trajectory.add_point(Vector2(0,0))
	ray.cast_to.x = max(OS.window_size.x, OS.window_size.y)
	
	if is_instance_valid(Global.game_manager):
		var _ok := self.connect("exp_retrieved", Global.game_manager, "exp_retrieved")


func _input(event):
	if event.is_action_pressed("deploy") and can_deploy:
		can_deploy = false
		get_or_create_drone()
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
	var drone_inst:KinematicBody2D = drone_scene.instance()
	self.add_child(drone_inst)
	drone_inst.init(deploy_point.global_position, deploy_point.global_rotation)
	return drone_inst


# Limits drone spamming
func _on_DeployCooldown_timeout():
	can_deploy = true


# Aura around the HUB that collects deployed drones
func _on_PickUpZone_body_entered(body):
	if body.is_in_group("DRONE"):
		if body.bounce_count > 0:
			collect_drone(body)


# Creates a line from the arrow to a collider
func emit_ray():
	if ray.is_colliding():
		trajectory_pt.global_position = ray.get_collision_point()
		trajectory.set_point_position(1, trajectory_pt.position - yellow_arrow.offset)


# Handles drone given in parameter
func collect_drone(drone:Drone):
	drone.disable()
	# Have to set deferred or else drones will randomly slide across the map
	drone.set_deferred("global_position", Vector2(16, drone_list.find(drone)*32 + 16))
	emit_signal("exp_retrieved", drone.exp_held)
	drone.exp_held = 0




func get_or_create_drone():
	if drone_list.size() < max_drones:
		drone_list.append(spawn_drone())
	else:
		for i in drone_list.size():
			if drone_list[i].state == 1:
				drone_list[i].init(deploy_point.global_position, deploy_point.global_rotation)
				break
