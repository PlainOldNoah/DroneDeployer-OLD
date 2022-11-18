extends Control

export var exp_enabled:bool = true

onready var crafting_core_container := $MarginContainer/VBoxContainer/Body/VBoxContainer/CraftingCoreContainer
onready var queue := $MarginContainer/VBoxContainer/Body/CraftingQueue/MarginContainer/ScrollContainer/QueueItemContainer

var queue_item_scene:String = "res://components/craft_queue_item.tscn"

var craft_history:Dictionary = {}


func reset():
	craft_history = {}


# Keeps a record of how many times each item was crafted
func update_craft_history(item:String):
	if craft_history.has(item):
		craft_history[item] = craft_history[item] + 1
	else:
		craft_history[item] = 1


# Adds a new LineEdit node to the queue
func add_item_2_queue(value:String=""):
# Verify item is in crafting options
	if not Global.crafting_options.has(value):
		print_debug("ERROR: ", value, " does not exist as an option")
		return
	
	var queue_item:Node = load(queue_item_scene).instance()
	update_craft_history(value)
	queue_item.initialize(value, craft_history[value])
	queue.add_child(queue_item)
	
	queue_2_core()


# Attempts to move the first item in the queue into an open crafting core
func queue_2_core():
	if queue.get_child_count() == 0:
		return
	
	for core in crafting_core_container.get_children(): # Check each core
		if core.running == false:
			for child in queue.get_children(): # Check each child
				if child.craftable and verify_cost(child.item_details.craft_cost):
					child.craftable = false
					core.craft(child.ref_item, child.text)
					child.queue_free()
					break


# Checks if player has enough xp for the current craft
func verify_cost(cost:int) -> bool:
	if exp_enabled:
		if Global.game_manager.curr_exp >= cost:
			Global.game_manager.curr_exp -= cost
			return true
		else:
			return false
	return true


# When a core is freed up check if anything in the queue can be processed
func core_freed():
	queue_2_core()


func _on_DroneBtn_pressed():
	add_item_2_queue("drone")


func _on_HealthBtn_pressed():
	add_item_2_queue("health")


func _on_ModBtn_pressed():
	add_item_2_queue("mod")
