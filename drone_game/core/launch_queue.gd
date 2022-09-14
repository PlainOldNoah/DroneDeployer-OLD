extends Control

# Shows the "up next" child in the queue
export var debug_show_up_next_in_queue:bool = false

onready var up_next_position := $MarginContainer/VBoxContainer/CautionRect/MarginContainer/UpNext
onready var queue_item_container := $MarginContainer/VBoxContainer/VBoxContainer
onready var launch_queue_item_scene := "res://components/launch_queue_item.tscn"


func launch_up_next():
	up_next_position.texture = null
	set_up_next_texture(1) # Use the second child texture while first is removed
	remove_from_queue(0)


# Sets the "up next" texture to the child_idx texture. Parameter changes based on where it's called
func set_up_next_texture(child_idx:int):
	if queue_item_container.get_child_count() > child_idx:
		var focused_child := queue_item_container.get_child(child_idx)
		focused_child.visible = debug_show_up_next_in_queue
		up_next_position.texture = focused_child.texture
		up_next_position.modulate = focused_child.modulate


# Creates a new launch queue item and adds it to the container
func add_to_queue(drone:Drone):
	var queue_item_inst = load(launch_queue_item_scene).instance()
	queue_item_container.add_child(queue_item_inst)
	queue_item_inst.texture = drone.get_sprite()
	
	queue_item_inst.modulate = drone.modulate # TEMP: Take the modulation with itself
	set_up_next_texture(0) # Uses the first childs texture


# Moves child in position idx and sends it to the back of the queue
func move_to_back(idx:int):
	var temp_child:Node = queue_item_container.get_child(idx)
	queue_item_container.remove_child(temp_child)
	queue_item_container.add_child(temp_child)
	temp_child.show()
	set_up_next_texture(0)


# Clears the queue item texture and moves it to the end
func remove_from_queue(idx:int):
	if queue_item_container.get_child(idx) != null:
		queue_item_container.get_child(idx).queue_free()
