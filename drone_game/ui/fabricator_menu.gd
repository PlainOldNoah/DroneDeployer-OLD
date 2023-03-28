extends Control

@onready var core_parent := $MarginContainer/HBoxContainer/CraftingCores/CraftingCorePanel/MarginContainer/CraftCoreInnerMargin/CraftingCoreGrid
@onready var queue_item_container := $MarginContainer/HBoxContainer/CraftingQueue/MarginContainer/QueueItemContainer


func _ready():
	Global.fabricator = self


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
		if core.available and not focused_child.available:
			core.start_new_sequence(focused_child.item_ref["id"])
			queue_item_container.move_child(focused_child, queue_item_container.get_child_count())
			focused_child.reset()
			break


func _on_crafting_core_freed():
	queue_to_core()


func _on_new_drone_btn_pressed():
	add_to_queue("drone")


func _on_repair_btn_pressed():
	add_to_queue("health")


func _on_enhancement_btn_pressed():
	add_to_queue("mod")
