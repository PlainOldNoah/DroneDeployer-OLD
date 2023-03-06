extends Control

@export var exp_enabled:bool = true

@onready var crafting_core_container := $MarginContainer/VBoxContainer/Body/VBoxContainer/CraftingCoreContainer
@onready var queue := $MarginContainer/VBoxContainer/Body/CraftingQueue/MarginContainer/ScrollContainer/QueueItemContainer

var queue_item_scene:String = "res://components/craft_queue_item.tscn"

var craft_history:Dictionary = {}


func _ready():
	Global.fabricator = self


func reset():
	craft_history = {}


# Keeps a record of how many times each item was crafted
func update_craft_history(item:String):
	if craft_history.has(item):
		craft_history[item] = craft_history[item] + 1
	else:
		craft_history[item] = 1


# Adds a new craft_queue_item node to the queue
func add_item_2_queue(value:String=""):
# Verify item is in crafting options
	if not CraftOpt.fabricator_items.has(value):
		print_debug("ERROR: ", value, " does not exist as an option")
		return
	
	var queue_item:Node = load(queue_item_scene).instantiate()
	update_craft_history(value)
	queue.add_child(queue_item)
	var _ok := queue_item.connect("left_click",Callable(self,"reorder_queue_item"))
	_ok = queue_item.connect("right_click",Callable(self,"remove_item_from_queue"))
	queue_item.initialize(value, craft_history[value])
	
	queue_2_core()


# Deletes the item from the crafting queue
func remove_item_from_queue(item:Node):
	item.call_deferred("queue_free")


# Changes the ordering of the queue item
func reorder_queue_item(item:Node, pos:int=0):
	queue.call_deferred("move_child", item, pos)
#	queue.move_child(item, position)


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


# When a core finishes it's job allow the fabricator to finish the task
func _on_craft_complete(crafted_item:String):
	match crafted_item:
		"drone":
			Global.drone_manager.increment_max_drones(1)
		"health":
			Global.game_manager.modify_health(1)
		"mod":
			Global.mod_manager.generate_rand_enhancement()
		_:
			print_debug("ERROR: ", crafted_item, " is not a valid craftable item")

	Logger.create(self, "fabrication", str(crafted_item + " fabricated"))


func _on_NewDroneBtn_pressed():
	add_item_2_queue("drone")


func _on_HealthBtn_pressed():
	add_item_2_queue("health")


func _on_EnhancementBtn_pressed():
	add_item_2_queue("mod")
