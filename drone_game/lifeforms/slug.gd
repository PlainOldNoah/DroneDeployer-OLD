extends "res://lifeforms/generic_lifeform.gd"

@onready var slime_trail := preload("res://objects/slug_slime.tscn")
@onready var slime_placer := $SlimePlacer

var on_slime:bool = false

func _input(event):
	if event.is_action_pressed("ui_page_down"):
		load_data("slug_t1")
#		add_slime_if_needed()


func _ready():
	super._ready()
	Global.add_to_groups(self, ["SLUG", "ENEMY"])


# OVERRIDE to have slugs follow the HUB should it happen to move
func _physics_process(delta):
	set_target_destination(Global.hub_scene)
	super._physics_process(delta)


# OVERRIDE Different behavior for hitting drone or the hub
func handle_collision(collision:KinematicCollision2D):
	if collision.get_collider().is_in_group("HUB"):
		queue_free()


func set_state(new_state:STATES):
	super.set_state(new_state)
	if new_state == STATES.ACTIVE:
		add_slime_if_needed()


# Places down a slug_slime node
func create_slime():
	var slime_inst = slime_trail.instantiate()
	await get_tree().process_frame # Things break without this
	Global.gameboard.add_object(slime_inst)
	slime_inst.variate_texture()
	slime_inst.global_position = slime_placer.global_position
	slime_inst.spawn_in()


func add_slime_if_needed():
	if slime_placer.get_overlapping_areas().is_empty():
		create_slime()


func _on_ImmunityTimer_timeout():
	super._on_ImmunityTimer_timeout()
	add_slime_if_needed()


func _on_gameboard_detector_area_entered(area):
	add_slime_if_needed()


func _on_slime_placer_area_entered(_area):
	on_slime = true


func _on_slime_placer_area_exited(_area):
	on_slime = false
	add_slime_if_needed()
