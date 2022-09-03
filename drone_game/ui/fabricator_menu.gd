extends Control

onready var crafting_core_container := $MarginContainer/VBoxContainer/Body/VBoxContainer/CraftingCoreContainer
onready var queue := $MarginContainer/VBoxContainer/Body/CraftingQueue/MarginContainer/ScrollContainer/QueueItemContainer


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
		
# Creating the LineEdit
	var queue_item = LineEdit.new()
	queue_item.name = "queue_item"
	queue_item.editable = false
	queue_item.context_menu_enabled = false
	queue_item.selecting_enabled = false
	
# Using the LineEdit
	var item:Dictionary = Global.crafting_options[value]
	crafting_queue.append(value)
	queue_item.text = item.name + ": " + str(temp_clicks)
	queue_item.right_icon = load(item.icon)
	queue.add_child(queue_item)
	
	queue_2_core()


# Attempts to move the first item in the queue into an open crafting core
func queue_2_core():
	if crafting_queue.empty():
		return
	
	for core in crafting_core_container.get_children():
		if core.running == false:
			core.craft(crafting_queue[0])
			crafting_queue.remove(0)
			queue.get_child(0).queue_free()
			break


# When a core is freed up check if anything in the queue can be processed
func core_freed():
	queue_2_core()
