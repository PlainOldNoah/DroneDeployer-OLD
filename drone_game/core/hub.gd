class_name Hub
extends Area2D

signal hit_taken()

@export var rotation_weight:float = 0.2

@onready var ray := $Deployer/TrajectoryRay
@onready var trajectory := $TrajectoryLine
@onready var pickup_zone := $PickUpZone
@onready var deployer := $Deployer
@onready var deploy_point := $Deployer/DeployPoint
@onready var deploy_cooldown := $DeployCooldown
@onready var skip_cooldown := $SkipCooldown

var can_deploy:bool = true
var can_skip:bool = true
var DEBUG_INVINCIBLE:bool = false


func _ready():
	Global.hub_scene = self
	await get_tree().root.ready
	Global.add_to_groups(self, ["HUB"])
	
	trajectory.add_point(Vector2(0,0))
	trajectory.add_point(Vector2(0,0))
	
	ray.target_position.x = get_window().size.x * (1.5) # Not really sure what this constant is
#	print_debug(ray.target_position.x)
	
	if is_instance_valid(Global.game_manager):
		var _ok = self.connect("hit_taken",Callable(Global.game_manager,"take_hit"))


func _process(_delta):
#	check_for_internal_drones()
	rotate_arrow_smooth()
	emit_ray()


func check_for_internal_drones():
	if pickup_zone.get_overlapping_bodies().size() > 0:
		for i in pickup_zone.get_overlapping_bodies():
			print(i)
			if i.is_in_group("DRONE") and i.bounce_count > 0:
				collect_drone(i)


# DEPRECIATED
# Rotate the deployment arrow to look at the cursor
func rotate_arrow():
	deployer.look_at(get_global_mouse_position())
	if Input.is_action_pressed("deploy_snap"):
		deployer.rotation_degrees = snapped(deployer.rotation_degrees, 45)


# Deploy vector follows the mouse but rotates smoothly
func rotate_arrow_smooth():
	var angle = (get_global_mouse_position() - self.global_position).angle()
	if Input.is_action_pressed("deploy_snap"):
		deployer.global_rotation = lerp_angle(deployer.global_rotation, snapped(angle, PI/4), rotation_weight)
	else:
		deployer.global_rotation = lerp_angle(deployer.global_rotation, angle, rotation_weight)


# Retrieves the first drone from the queue and deploys it
func deploy_drone():
	can_deploy = false
	DroneManager.deploy_next_up(deploy_point.global_position, deploy_point.global_rotation)
	deploy_cooldown.start(Global.game_manager.drone_deploy_cooldown)


func skip_drone():
	can_skip = false
	DroneManager.skip_up_next()
	skip_cooldown.start(Global.game_manager.drone_deploy_cooldown)


# Handles drone given in parameter
func collect_drone(drone:Drone):
	DroneManager.collect_drone(drone)


# Limits drone spamming
func _on_DeployCooldown_timeout():
	can_deploy = true


func _on_SkipCooldown_timeout():
	can_skip = true


# Creates a line from the arrow to a collider
func emit_ray():
	if ray.is_colliding():
		trajectory.set_point_position(0, to_local(deploy_point.global_position))
		trajectory.set_point_position(1, to_local(ray.get_collision_point()))


# Aura around the HUB that collects deployed drones
func _on_PickUpZone_body_entered(body):
	if body.is_in_group("DRONE") and body.state == body.STATES.ACTIVE:
		collect_drone(body)


# Changes drone state from SPAWNING to ACTIVE
func _on_PickUpZone_body_exited(body):
	if body.is_in_group("DRONE") and body.state == Drone.STATES.SPAWNING:
		body.state = Drone.STATES.ACTIVE


func _on_Hub_body_entered(body):
	if body.is_in_group("ENEMY"):
		if not DEBUG_INVINCIBLE: emit_signal("hit_taken", 1)
		body.queue_free()
