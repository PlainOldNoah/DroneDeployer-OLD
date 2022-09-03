extends MarginContainer

signal core_freed() # Emit when a core stops being in use

onready var item_icon := $NinePatchRect/InnerMargin/VBoxContainer/CraftingIcon
onready var item_label := $NinePatchRect/InnerMargin/VBoxContainer/CraftingNameLabel
onready var item_craft_time := $NinePatchRect/InnerMargin/VBoxContainer/CraftTimeLeft
onready var timer := $Timer

var item_to_craft:String = ""
var seconds:int = 0 # Seconds that craft takes, counts down
var running:bool = false


func _ready():
	reset_core()
	self.connect("core_freed", get_owner(), "core_freed")


# Sets the core's info to default values
func reset_core():
	timer.stop()
	item_icon.texture = load("res://assets/red_x.png")
	item_label.text = "Idle"
	item_craft_time.text = "0:00"
	item_to_craft = ""
	seconds = 0
	free_core()


# Sets the core to not running and emits the signal
func free_core():
	running = false
	emit_signal("core_freed")


# Sets core to running and populates with needed info
func craft(item:String):
	running = true
	item_to_craft = item
	item_icon.texture = load(Global.crafting_options[item].icon)
	item_label.text = Global.crafting_options[item].name
	seconds = Global.crafting_options[item].craft_time
	update_time()
	timer.start()


# When a craft is complete call this function
func craft_complete():
	if item_to_craft == "drone":
		Global.game_manager.build_new_drone()
#		print(self.name, " crafted ", item_to_craft)
	reset_core()


# Each second update the time label and verify if it's 0
func update_time():
	if seconds <= 0:
		craft_complete()
	item_craft_time.text = str(seconds)


# Stops the core's current craft
func _on_CancelButton_pressed():
	reset_core()


func _on_Timer_timeout():
	seconds -= 1
	update_time()
