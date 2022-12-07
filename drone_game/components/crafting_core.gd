extends MarginContainer

signal core_freed() # Lets the fabricator know that this core is no longer being used
signal craft_completed()

onready var item_icon := $NinePatchRect/InnerMargin/VBoxContainer/CraftingIcon
onready var item_label := $NinePatchRect/InnerMargin/VBoxContainer/CraftingNameLabel
onready var item_craft_time := $NinePatchRect/InnerMargin/VBoxContainer/CraftTimeLeft
onready var timer := $Timer

var item_to_craft:String = ""
var seconds:int = 0 # Seconds that craft takes, counts down
var running:bool = false


func _ready():
	yield(get_tree().root, "ready")
	reset_core()
	var _ok = connect("core_freed", Global.fabricator, "queue_2_core")
	_ok = Global.game_manager.connect("game_paused", self, "pause_core")
	_ok = connect("craft_completed", Global.fabricator, "_on_craft_complete")


# Sets the core's info to default values
func reset_core():
	timer.stop()
	item_icon.texture = load("res://assets/visual/red_x.png")
	item_label.text = "Idle"
	item_craft_time.text = "0:00"
	item_to_craft = ""
	seconds = 0
	running = false
	emit_signal("core_freed")


func pause_core(value:bool):
	timer.set_paused(value)


# Sets core to running and populates with needed info
func craft(item:String, temp_name:String):
	var item_details:Dictionary = Global.crafting_options[item]
	
	running = true
	item_to_craft = item
	item_icon.texture = load(item_details.icon)
	item_label.text = temp_name
#	item_label.text = item_details.name
	seconds = item_details.craft_time
	update_time()
	timer.start()


# Each second update the time label and verify if it's 0
func update_time():
	if seconds <= 0:
		emit_signal("craft_completed", item_to_craft)
		reset_core()
	item_craft_time.text = (str(seconds / 60) + ":" + str(seconds % 60).pad_zeros(2))


# Stops the core's current craft
func _on_CancelButton_pressed():
	reset_core()


func _on_Timer_timeout():
	seconds -= 1
	update_time()
