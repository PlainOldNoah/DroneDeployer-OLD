extends Control

const offset:int = 65

var tween_time:float = 0

onready var queue_item_container := $MarginContainer/QueueItemContainer
onready var launch_queue_item_scene := "res://components/launch_queue_item.tscn"
onready var tween:Tween = $Tween
onready var entry_timer:Timer = $EntryTimer

#var queue_locked:bool = false # Bool to check if tween is currently doing something
var pre_queue:Array = [] # Holds nodes waiting to enter the queue, pre-queue


func _ready():
	yield(get_tree().root, "ready")
	tween_time = Global.game_manager.deploy_cooldown
	entry_timer.wait_time = Global.game_manager.deploy_cooldown


# Creates a new launch queue item and adds it to the container
func add_to_queue(drone:Drone):
	var queue_item_inst = load(launch_queue_item_scene).instance()
	queue_item_container.add_child(queue_item_inst)
	queue_item_inst.texture = drone.get_sprite()
	
	queue_item_inst.modulate = drone.modulate # TEMP: Take the modulation with itself
	
#	queue_item_inst.rect_position.y = (queue_item_container.get_child_count() - 1) * offset #DEBUG: Fast Mode
#	print("Here?")
	enter_queue(queue_item_inst)


func launch_up_next():
	pop_up_next()
	yield(tween, "tween_all_completed")
	remove_from_queue(0)


# Moves drone at front to back and stages it for reentry
func move_to_back(idx:int):
	pop_up_next()
	
	enter_queue(queue_item_container.get_child(idx))
	
	queue_item_container.move_child(queue_item_container.get_child(idx), queue_item_container.get_child_count())
	
#	for i in queue_item_container.get_child_count():
#		var focus_child:LaunchQueueItem = queue_item_container.get_child(i)
#		if not pre_queue.has(focus_child):
#			tween.interpolate_property(focus_child, "rect_position", focus_child.rect_position, Vector2(focus_child.rect_position.x, (focus_child.get_index()) * offset), tween_time, Tween.TRANS_LINEAR)
#	tween.start()


# Up next drone travels forwards off of the screen
func pop_up_next():
	for i in queue_item_container.get_child_count():
		var focus_child:LaunchQueueItem = queue_item_container.get_child(i)
		match i:
			0: 
				tween.interpolate_property(focus_child, "rect_position", focus_child.rect_position, Vector2(focus_child.rect_position.x, -100), tween_time, Tween.TRANS_SINE)
			_: 
				if not pre_queue.has(focus_child):
					tween.interpolate_property(focus_child, "rect_position", focus_child.rect_position, Vector2(focus_child.rect_position.x, (focus_child.get_index() - 1) * offset), tween_time, Tween.TRANS_LINEAR)
	tween.start()


# Places queue item off screen preparing to tween into the queue
func enter_queue(q_item_inst:LaunchQueueItem):
	pre_queue.append(q_item_inst)
	q_item_inst.rect_position = Vector2(q_item_inst.rect_position.x, 1000)
	entry_timer.start()


# Clears the queue item texture and moves it to the end
func remove_from_queue(idx:int):
	if queue_item_container.get_child(idx) != null:
		queue_item_container.get_child(idx).queue_free()


func _on_EntryTimer_timeout():
	tween.interpolate_property(pre_queue[0], "rect_position", Vector2(pre_queue[0].rect_position.x, 1000), Vector2(pre_queue[0].rect_position.x, pre_queue[0].get_index() * offset), tween_time, Tween.TRANS_LINEAR)
#	tween.interpolate_property(pre_queue[0], "rect_position", pre_queue[0].rect_position, Vector2(pre_queue[0].rect_position.x, pre_queue[0].get_index() * offset), tween_time, Tween.TRANS_LINEAR)
	tween.start()
	pre_queue.pop_front()
	if not pre_queue.empty():
		entry_timer.start()
