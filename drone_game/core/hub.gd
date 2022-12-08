class_name Hub
extends Node2D

signal hit_taken()

export var rotation_weight:float = 0.2

onready var deployer:Sprite = $Deployer
onready var deploy_point = $Deployer/DeployPoint
onready var deploy_cooldown:Timer = $DeployCooldown
onready var skip_cooldown:Timer = $SkipCooldown

onready var ray:RayCast2D = $Deployer/TrajectoryRay
onready var trajectory:Line2D = $TrajectoryLine

var can_deploy:bool = true
var can_skip:bool = true
var debug_invincible:bool = false


func _ready():
	Global.hub_scene = self
	yield(get_tree().root, "ready")
	GroupMan.add_to_groups(self, ["HUB"])
	
	trajectory.add_point(Vector2(0,0))
	trajectory.add_point(Vector2(0,0))
	ray.cast_to.x = max(OS.window_size.x, OS.window_size.y)
	
	if is_instance_valid(Global.game_manager):
		var _ok = self.connect("hit_taken", Global.game_manager, "take_hit")


func _input(event):
	if event.is_action_pressed("deploy") and can_deploy:
		can_deploy = false
		deploy_drone()
		deploy_cooldown.start(1)
	elif event.is_action_pressed("deploy_skip") and can_skip:
		can_skip = false
		skip_drone()
		skip_cooldown.start(0.25)


func _process(_delta):
	rotate_arrow_smooth()
	emit_ray()


# DEPRECIATED
# Rotate the deployment arrow to look at the cursor
func rotate_arrow():
	deployer.look_at(get_global_mouse_position())
	if Input.is_action_pressed("deploy_snap"):
		deployer.rotation_degrees = stepify(deployer.rotation_degrees, 45)


# Deploy vector follows the mouse but rotates smoothly
func rotate_arrow_smooth():
	var angle = (get_global_mouse_position() - self.global_position).angle()
	if Input.is_action_pressed("deploy_snap"):
		deployer.global_rotation = lerp_angle(deployer.global_rotation, stepify(angle, PI/4), rotation_weight)
	else:
		deployer.global_rotation = lerp_angle(deployer.global_rotation, angle, rotation_weight)


# Retrieves the first drone from the queue and deploys it
func deploy_drone():
	Global.drone_manager.deploy_next_up(deploy_point.global_position, deploy_point.global_rotation)


func skip_drone():
	Global.drone_manager.skip_up_next()


# Handles drone given in parameter
func collect_drone(drone:Drone):
	Global.drone_manager.collect_drone(drone)


# Limits drone spamming
func _on_DeployCooldown_timeout():
	can_deploy = true


func _on_SkipCooldown_timeout():
	can_skip = true


# Aura around the HUB that collects deployed drones
func _on_PickUpZone_body_entered(body):
#	print(body, ": ", body.state, ": ", body.bounce_count)
	if body.is_in_group("DRONE") and body.state == body.STATES.ACTIVE:
#		if body.bounce_count > 0:
		collect_drone(body)


# Creates a line from the arrow to a collider
func emit_ray():
	if ray.is_colliding():
		trajectory.set_point_position(0, to_local(deploy_point.global_position))
		trajectory.set_point_position(1, to_local(ray.get_collision_point()))


func _on_Hitbox_body_entered(body):
	if body.is_in_group("ENEMY"):
		if not debug_invincible: emit_signal("hit_taken", 1)
		body.queue_free() # TODO: If I want to make this more fancy later


func _on_PickUpZone_body_exited(_body):
#	print(body)
	pass
