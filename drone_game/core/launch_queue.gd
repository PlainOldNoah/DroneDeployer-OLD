extends Control

onready var queue_item_container := $MarginContainer/VBoxContainer/VBoxContainer
onready var launch_queue_item_scene := "res://components/launch_queue_item.tscn"
onready var tween:Tween = $Tween

var queue_locked:bool = false # Bool to check if tween is currently doing something

const offset:int = 65

func launch_up_next():
	tween_move_first()
	
	remove_from_queue(0)
	increment_queue()


# Creates a new launch queue item and adds it to the container
func add_to_queue(drone:Drone):
	var queue_item_inst = load(launch_queue_item_scene).instance()
	queue_item_container.add_child(queue_item_inst)
	queue_item_inst.texture = drone.get_sprite()
	
	queue_item_inst.modulate = drone.modulate # TEMP: Take the modulation with itself
	
	tween_append_back(queue_item_inst)


func tween_append_back(queue_item_inst:Node):
	var starting_pos:Vector2 = Vector2(0, 800)
	var target_pos:Vector2 = Vector2(0, (queue_item_container.get_child_count() - 1) * offset)
	tween.interpolate_property(queue_item_inst, "rect_position", starting_pos, target_pos, 1, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	reconcile_queue()

func tween_move_first():
	tween.interpolate_property(queue_item_container.get_child(0), "rect_position", queue_item_container.get_child(0).rect_position, Vector2(0, -100), 0.25, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	reconcile_queue()

func increment_queue():
	for i in queue_item_container.get_child_count() - 1:
		var focused_child:Node = queue_item_container.get_child(i)
		if focused_child.rect_position != Vector2(0, i * offset): # Check for drones in the wrong position
			tween.interpolate_property(focused_child, "rect_position", focused_child.rect_position, Vector2(0, (i + 1) * offset), 1, Tween.TRANS_LINEAR)
			tween.start()
			yield(tween, "tween_completed")


func reconcile_queue():
	for i in queue_item_container.get_child_count():
		var focused_child:Node = queue_item_container.get_child(i)
		if focused_child.rect_position != Vector2(0, i * offset): # Check for drones in the wrong position
			tween.interpolate_property(focused_child, "rect_position", focused_child.rect_position, Vector2(0, i * offset), 1, Tween.TRANS_LINEAR)
			tween.start()
			yield(tween, "tween_completed")


# Moves child in position idx and sends it to the back of the queue
func move_to_back(idx:int):
	var temp_child:Node = queue_item_container.get_child(idx)
	queue_item_container.remove_child(temp_child)
	queue_item_container.add_child(temp_child)
	
	var starting_pos:Vector2 = Vector2(0, 800)
	var target_pos:Vector2 = Vector2(0, (queue_item_container.get_child_count() - 1) * offset)
	tween.interpolate_property(temp_child, "rect_position", starting_pos, target_pos, 1, Tween.TRANS_LINEAR)
	tween.start()


# Clears the queue item texture and moves it to the end
func remove_from_queue(idx:int):
	if queue_item_container.get_child(idx) != null:
		queue_item_container.get_child(idx).queue_free()
