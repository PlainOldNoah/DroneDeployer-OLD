extends Control

@onready var queue_item_container := $ContentContainer/MarginContainer/QueueItemContainer
@onready var drone_mirror_scene := "res://ui/components/drone_mirror.tscn"

var drone_manager:DroneManager = null
var queue:Array = []
var launch_enabled:bool = true # TODO: Work on this later. Needs to talk to HUB?


func _ready():
	Global.launch_queue = self
	await get_tree().root.ready
	drone_manager = Global.drone_manager
	
	var _ok := drone_manager.connect("drone_added_to_queue",Callable(self,"create_queue_item"))
	_ok = drone_manager.connect("drone_launched",Callable(self,"deploy_up_next"))
	_ok = drone_manager.connect("drone_skipped",Callable(self,"skip_up_next"))


# Makes a new queue item for the given drone
func create_queue_item(drone:Drone):
	var drone_mirror = load(drone_mirror_scene).instantiate()
	queue_item_container.add_child(drone_mirror)
	
	drone_mirror.init(64, false, true)
	drone_mirror.set_drone(drone)
	
	queue.append(drone_mirror)


# Pops the next drone in line and deletes the mirror
func deploy_up_next(_drone:Drone):
	if not launch_enabled:
		return
	
	var up_next := queue_item_container.get_child(0)
	
	queue.pop_front()
	up_next.queue_free()


# Sends the mirror the end of the line
func skip_up_next():
	if not launch_enabled:
		return
	
	var up_next := queue_item_container.get_child(0)
	
	queue.pop_front()
	queue_item_container.move_child(up_next, queue_item_container.get_child_count())


func _on_QueueItemContainer_resized():
	var limit_factor:int = queue_item_container.size.x
	for mirror in queue_item_container.get_children():
		mirror.set_rect_size(limit_factor)


# Hides the popup from each child drone mirror
func dismiss_popups():
	for i in queue_item_container.get_children():
		i.toggle_popup(false)
