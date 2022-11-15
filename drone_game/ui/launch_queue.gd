extends Control

const offset:int = 65

var tween_time:float = 0

onready var queue_item_container := $MarginContainer/QueueItemContainer
onready var launch_queue_item_scene := "res://components/launch_queue_item.tscn"
onready var tween:Tween = $Tween
onready var entry_timer:Timer = $EntryTimer

#var queue_locked:bool = false # Bool to check if tween is currently doing something
var drone_manager:DroneManager = null
var queue:Array = []
var launch_enabled:bool = true # TODO: Work on this later. Needs to talk to HUB?
var condensing:bool = false

var off_screen_top:int = 0
var off_screen_bottom:int = 0


func _ready():
	yield(get_tree().root, "ready")
	tween_time = Global.game_manager.deploy_cooldown
	entry_timer.wait_time = Global.game_manager.deploy_cooldown
	drone_manager = Global.drone_manager
	
	off_screen_top = -self.rect_global_position.y - (2 * offset)
	off_screen_bottom = self.rect_global_position.y + rect_size.y + offset
	
	var _ok := drone_manager.connect("drone_added_to_queue", self, "create_queue_item")
	_ok = drone_manager.connect("drone_launched", self, "deploy_up_next")


# Makes a new queue item for the given drone
func create_queue_item(drone:Drone):
#	print("STACK: create_queue_item")
	
	var queue_item_inst = load(launch_queue_item_scene).instance()
	queue_item_container.add_child(queue_item_inst)
	queue_item_inst.texture = drone.get_sprite()

	queue_item_inst.modulate = drone.modulate # TEMP: Take the modulation with itself
	
	enter_queue(queue_item_inst)


# Adds the queue_item_inst into an array
func enter_queue(queue_item_inst:LaunchQueueItem):
	queue_item_inst.rect_position = Vector2(queue_item_inst.rect_position.x, off_screen_bottom)
	queue.append(queue_item_inst)
	
	condense_queue()


# Moves all queue items to their correct positions
func condense_queue():
	if queue.empty() or condensing:
		return self
	
#	condensing = true
	
	for i in queue.size():
		queue[i].rect_position.y = i * offset
#		tween.interpolate_property(queue[i], "rect_position", null, Vector2(queue[i].rect_position.x, i * offset), 0.5, Tween.TRANS_SINE)
#	tween.start()
	

#	condensing = false
#	return


# Pops the next drone in line, either deletes it or has it reenter the queue
func deploy_up_next(delete_up_next:bool=true):
#	print("STACK: deploy_up_next")
	if not launch_enabled:
		return
	
	var up_next:LaunchQueueItem = queue[0]
	
#	tween.interpolate_property(up_next, "rect_position", null, Vector2(up_next.rect_position.x, off_screen_top), 0.5, Tween.TRANS_SINE)
#	tween.start()
#	yield(tween, "tween_completed")
	
	queue.pop_front()
	
	if delete_up_next:
		up_next.queue_free()
		call_deferred("condense_queue")
	else:
		up_next.rect_position.y = off_screen_bottom
		call_deferred("enter_queue", up_next)
	
#	print("deploy_up_next finished")


func _on_Tween_tween_completed(object, _key):
	if queue[0] == object:
		launch_enabled = true


func _on_Tween_tween_started(object, _key):
	if queue[0] == object:
		launch_enabled = false
