class_name Hub
extends StaticBody2D

signal exp_retrieved()
signal hit_taken()

export var rotation_weight:float = 0.2

onready var yellow_arrow:Sprite = $YellowArrow
onready var deploy_point = $YellowArrow/DeployPoint
onready var deploy_cooldown:Timer = $DeployCooldown

onready var ray:RayCast2D = $YellowArrow/TrajectoryRay
onready var trajectory:Line2D = $TrajectoryLine

var drone_scene = preload("res://lifeforms/drone.tscn")
var can_deploy:bool = true
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
		_ok = self.connect("hit_taken", Global.game_manager, "take_hit")


func _input(event):
	if event.is_action_pressed("deploy") and can_deploy:
		can_deploy = false
		deploy_drone()
		deploy_cooldown.start()
	elif event.is_action_pressed("deploy_skip") and can_deploy:
		skip_drone()


func _process(_delta):
	rotate_arrow_smooth()
	emit_ray()


# DEPRECIATED
# Rotate the arrow to use arrow keys
func rotate_arrow_degree():
	var direction:float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_action_pressed("deploy_snap"):
		yellow_arrow.rotation_degrees = lerp(yellow_arrow.rotation_degrees, stepify(yellow_arrow.rotation_degrees, 45), 0.1)
	else:
		yellow_arrow.rotation_degrees += direction * 3


# DEPRECIATED
# Rotate the deployment arrow to look at the cursor
func rotate_arrow():
	yellow_arrow.look_at(get_global_mouse_position())
	if Input.is_action_pressed("deploy_snap"):
		yellow_arrow.rotation_degrees = stepify(yellow_arrow.rotation_degrees, 45)


# Deploy vector follows the mouse but rotates smoothly
func rotate_arrow_smooth():
	if Input.is_action_pressed("deploy_snap"):
		yellow_arrow.rotation_degrees = lerp(yellow_arrow.rotation_degrees, stepify(yellow_arrow.rotation_degrees, 45), rotation_weight)
	else:
		var angle = (get_global_mouse_position() - self.global_position).angle()
		yellow_arrow.global_rotation = lerp_angle(yellow_arrow.global_rotation, angle, rotation_weight)


# Retrieves the first drone from the queue and deploys it
func deploy_drone():
	Global.game_manager.deploy_next_up(deploy_point.global_position, deploy_point.global_rotation)


func skip_drone():
	Global.game_manager.skip_up_next()


# Handles drone given in parameter
func collect_drone(drone:Drone):
	drone.disable()
	drone.global_position = Vector2.ONE * 100
	emit_signal("exp_retrieved", drone.exp_held)
	drone.exp_held = 0
	Global.game_manager.add_drone_to_queue(drone)


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
		trajectory.set_point_position(0, to_local(deploy_point.global_position))
		trajectory.set_point_position(1, to_local(ray.get_collision_point()))


func _on_Hitbox_body_entered(body):
	if body.is_in_group("ENEMY"):
		emit_signal("hit_taken", 1)
