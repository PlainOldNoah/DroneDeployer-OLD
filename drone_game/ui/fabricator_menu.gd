extends Control

onready var crafting_core_container := $MarginContainer/VBoxContainer/Body/VBoxContainer/CraftingCoreContainer
onready var queue := $MarginContainer/VBoxContainer/Body/CraftingQueue/MarginContainer/ScrollContainer/QueueItemContainer
var queue_item_scene:String = "res://components/queue_item.tscn"

var crafting_queue:Array = []


var temp_clicks:int = 0
func _on_DroneBtn_pressed():
	temp_clicks += 1
	add_item_2_queue("drone")


# Adds a new LineEdit node to the queue
func add_item_2_queue(value:String=""):
# Verify item is in crafting options
	if not Global.crafting_options.has(value):
		print_debug(value, " does not exist as an option")
		return
	
	var queue_item:Node = load(queue_item_scene).instance()
	queue_item.initialize(value, temp_clicks)
	queue.add_child(queue_item)
	
	queue_2_core()


# Attempts to move the first item in the queue into an open crafting core
func queue_2_core():
	if queue.get_child_count() == 0:
		return
	
	for core in crafting_core_container.get_children():
		if core.running == false:
			for child in queue.get_children():
				if child.craftable:
					child.craftable = false
					core.craft(child.ref_item, child.text)
					child.queue_free()
					break


# When a core is freed up check if anything in the queue can be processed
func core_freed():
	queue_2_core()
