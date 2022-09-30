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
	yield(get_tree().root, "ready")
	reset_core()
	var _ok = self.connect("core_freed", get_owner(), "core_freed")
	_ok = Global.game_manager.connect("game_paused", self, "pause_core")


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


func pause_core(value:bool):
	timer.set_paused(value)
	pass


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


# When a craft is complete call this function
func craft_complete():
	match item_to_craft:
		"drone":
			Global.game_manager.increment_max_drones(1)
		"health":
			Global.game_manager.modify_health(1)
	
#	if item_to_craft == "drone":
		
	reset_core()


# Each second update the time label and verify if it's 0
func update_time():
	if seconds <= 0:
		craft_complete()
	item_craft_time.text = (str(seconds / 60) + ":" + str(seconds % 60).pad_zeros(2))


# Stops the core's current craft
func _on_CancelButton_pressed():
	reset_core()


func _on_Timer_timeout():
	seconds -= 1
	update_time()
