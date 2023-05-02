extends Control

@onready var core_parent := $MarginContainer/HBoxContainer/CraftingCores/CraftingCorePanel/MarginContainer/CraftCoreInnerMargin/CraftingCoreGrid
@onready var queue_item_container := $MarginContainer/HBoxContainer/CraftingQueue/MarginContainer/QueueItemContainer
@onready var available_scrap_ssd := $MarginContainer/HBoxContainer/CraftingCores/VBoxContainer/HBoxContainer/AvailableScrapSSD
@onready var spent_scrap_ssd := $MarginContainer/HBoxContainer/CraftingCores/VBoxContainer/HBoxContainer/SpentScrapSSD
@onready var lifetime_scrap_ssd := $MarginContainer/HBoxContainer/CraftingCores/VBoxContainer/HBoxContainer/LifetimeScrapSSD


func _ready():
	Global.fabricator = self
	await get_tree().root.ready
	var _ok = Global.game_manager.connect("curr_scrap_updated", _update_available_scrap)
	_ok = Global.game_manager.connect("spent_scrap_updated", _update_spent_scrap)


func reset():
	for i in queue_item_container.get_children():
		i.reset()


# Populates the queue items with upcoming crafts
func add_to_queue(item:String):
	for i in queue_item_container.get_children():
		if i.available:
			i.initialize(item)
			break
	
	queue_to_core()


# Transfers the first item in the queue to an available core
func queue_to_core():
	var focused_child:Node = queue_item_container.get_child(0)
	for core in core_parent.get_children():
		if (core.available and not focused_child.available) and\
		(Global.debug["USE_SCRAP"] == false or Global.game_manager.curr_scrap >= focused_child.item_ref["craft_cost"]):
			# Order matters here or else fabricator goes crazy
			queue_item_container.move_child(focused_child, queue_item_container.get_child_count())
			core.start_new_sequence(focused_child.item_ref["id"])
			focused_child.reset()
			break


func _on_crafting_core_freed():
	queue_to_core()


# Signal connected from craft buttons to here
# Additional String arg required from each btn
func _on_craft_btn_pressed(_click_action:String, item:String):
	add_to_queue(item)


# Signal from when a crafting queue btn is pressed
# left_mouse to move to top, right_click to remove from queue
func _on_craft_queue_btn_pressed(click_action:String, btn_num:int):
	var focused_child:Node = queue_item_container.get_child(btn_num)
	match click_action:
		"left_mouse":
			queue_item_container.move_child(focused_child, 0)
		"right_mouse":
			queue_item_container.get_child(btn_num).reset()
			queue_item_container.move_child(focused_child, queue_item_container.get_child_count())


func _update_available_scrap(value:int):
	available_scrap_ssd.set_value(value)


func _update_spent_scrap(value:int):
	spent_scrap_ssd.set_value(value)
