extends Control

onready var queue_item_container := $MarginContainer/QueueItemContainer
onready var drone_mirror_scene := "res://components/drone_mirror.tscn"

var drone_manager:DroneManager = null
var queue:Array = []
var launch_enabled:bool = true # TODO: Work on this later. Needs to talk to HUB?


func _ready():
	Global.launch_queue = self
	yield(get_tree().root, "ready")
	drone_manager = Global.drone_manager
	
	var _ok := drone_manager.connect("drone_added_to_queue", self, "create_queue_item")
	_ok = drone_manager.connect("drone_launched", self, "deploy_up_next")


# Makes a new queue item for the given drone
func create_queue_item(drone:Drone):
	var drone_mirror = load(drone_mirror_scene).instance()
	queue_item_container.add_child(drone_mirror)
	
	drone_mirror.init(64, false, true)
	drone_mirror.set_drone(drone)
	
	queue.append(drone_mirror)


# Pops the next drone in line, either deletes it or has it reenter the queue
func deploy_up_next(delete_up_next:bool=true):
	if not launch_enabled:
		return
	
	var up_next := queue_item_container.get_child(0)
	
	queue.pop_front()
	
	if delete_up_next: # Launching
		up_next.queue_free()
	else: # Skipping
		queue_item_container.move_child(up_next, queue_item_container.get_child_count())


func _on_QueueItemContainer_resized():
	var limit_factor:int = queue_item_container.rect_size.x
	for mirror in queue_item_container.get_children():
		mirror.set_rect_size(limit_factor)


# Hides the popup from each child drone mirror
func dismiss_popups():
	for i in queue_item_container.get_children():
		i.toggle_popup(false)
