extends Node2D

onready var ray_1 := $RayCast1
onready var ray_2 := $RayCast2
onready var ray_3 := $RayCast3

export var ray_scaler:int = 1
export var max_rays:int = 1


func _ready():
	ray_1.cast_to *= ray_scaler


func _process(_delta):
	calculate_trajectory()


# Chains raycasts together to plot out a path
func calculate_trajectory():
#	look_at(get_global_mouse_position())
#	rotation_degrees -= 90
#	$Line2D.set_point_position(0, ray_1.position)
#	$Line2D.set_point_position(1, to_local(ray_1.get_collision_point()))
#	$Line2D2.set_point_position(0, to_local(ray_1.get_collision_point()))
#	$Line2D2.set_point_position(1, to_local(Vector2.ZERO))
	
	if ray_1.is_colliding() and max_rays > 1:
#		$RayCast1/RedX.global_position = ray_1.get_collision_point()

		var r1_collision_pt = ray_1.get_collision_point()
		var r1_normal = ray_1.get_collision_normal()
#		print(r1_normal, ", ", r1_collision_pt)
		ray_2.global_position = r1_collision_pt
#		var forward = r1_collision_pt - global_position
		var reflection = r1_collision_pt.bounce(r1_normal)
		ray_2.global_rotation = reflection.angle()

#		var r1_collision_pt:Vector2 = ray_1.get_collision_point()
#		var r1_normal:Vector2 = ray_1.get_collision_normal()
#		ray_2.global_position = ray_1.get_collision_point() - global_position
#		ray_2.cast_to = r1_collision_pt.bounce(r1_normal)
		
		
#	if ray_1.is_colliding() and max_rays > 1:
#		ray_2.enabled = true
#		var r1_collision_pt:Vector2 = ray_1.get_collision_point()
#		var r1_normal:Vector2 = ray_1.get_collision_normal()
#		ray_2.global_position = r1_collision_pt + r1_normal
#		ray_2.cast_to = r1_collision_pt.bounce(r1_normal) * ray_scaler
		
#		if ray_2.is_colliding() and max_rays > 2:
#			ray_3.enabled = true
#			var r2_collision_pt:Vector2 = ray_2.get_collision_point()
#			var r2_normal:Vector2 = ray_2.get_collision_normal()
#			ray_3.global_position = r2_collision_pt + r2_normal
#			ray_3.cast_to = r2_collision_pt.bounce(r2_normal) * ray_scaler
#		else:
#			ray_3.enabled = false
#	else:
#		ray_2.enabled = false
