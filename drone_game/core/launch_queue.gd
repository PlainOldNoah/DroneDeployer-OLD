extends Control

const offset:int = 65

var tween_time:float = 0

onready var queue_item_container := $MarginContainer/QueueItemContainer
onready var launch_queue_item_scene := "res://components/launch_queue_item.tscn"
onready var tween:Tween = $Tween
onready var entry_timer:Timer = $EntryTimer

#var queue_locked:bool = false # Bool to check if tween is currently doing something
var pre_queue:Array = [] # Holds nodes waiting to enter the queue, pre-queue
var queue:Array = []
var launch_enabled:bool = true # TODO: Work on this later. Needs to talk to HUB?

func _ready():
	yield(get_tree().root, "ready")
	tween_time = Global.game_manager.deploy_cooldown
	entry_timer.wait_time = Global.game_manager.deploy_cooldown


# Makes a new queue item for the given drone
func create_queue_item(drone:Drone):
	var queue_item_inst = load(launch_queue_item_scene).instance()
	queue_item_container.add_child(queue_item_inst)
	queue_item_inst.texture = drone.get_sprite()

	queue_item_inst.modulate = drone.modulate # TEMP: Take the modulation with itself
	
	enter_queue(queue_item_inst)


# Adds the q_item_inst into an array to await further processing
func enter_queue(q_item_inst:LaunchQueueItem):
	q_item_inst.rect_position = Vector2(q_item_inst.rect_position.x, 500)
	queue.append(q_item_inst)
	
	condense_queue()


# Moves all queue items to their correct positions
func condense_queue():
	if queue.empty():
		return
	
	for i in queue.size():
		tween.interpolate_property(queue[i], "rect_position", null, Vector2(queue[i].rect_position.x, i * offset), 0.5, Tween.TRANS_SINE)
		tween.start()
#		yield(tween, "tween_completed")


# Removes the first node
func deploy_up_next():
	if not launch_enabled:
		print("Cannot launch")
		return
	
	var up_next:LaunchQueueItem = queue[0]
	
	tween.interpolate_property(up_next, "rect_position", null, Vector2(up_next.rect_position.x, -100), 0.5, Tween.TRANS_SINE)
	tween.start()
	yield(tween, "tween_completed")
	
	queue.pop_front()
	condense_queue()
	up_next.queue_free()


# Removes the first node and replaces it in the back
func skip_up_next():
	if not launch_enabled:
		print("Cannot launch")
		return
	
	var up_next:LaunchQueueItem = queue[0]
	
	tween.interpolate_property(up_next, "rect_position", null, Vector2(up_next.rect_position.x, -100), 0.5, Tween.TRANS_SINE)
	tween.start()
	yield(tween, "tween_completed")
	
	queue.pop_front()
	enter_queue(up_next)


func _on_Tween_tween_completed(object, key):
	if queue[0] == object:
		launch_enabled = true


func _on_Tween_tween_started(object, key):
	if queue[0] == object:
		launch_enabled = false
