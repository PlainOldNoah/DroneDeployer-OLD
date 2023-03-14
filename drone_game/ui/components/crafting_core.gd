@tool
extends PanelContainer

const PROGRESS_BAR_SEGMENTS:int = 11
const INFO_FORMAT_STRING:String = "%s\n%d Scrap       %d Sec"

signal craft_complete()

@export var core_number:int = 0 : set = set_core_number

@onready var progress_bar := $MarginContainer/HBoxContainer/TextureProgressBar
@onready var info_display := $MarginContainer/HBoxContainer/LeftVBox/PanelContainer/InfoMargin/CoreInfoDisplay
@onready var icon_display := $MarginContainer/HBoxContainer/LeftVBox/SingleIconDisplay
@onready var x_texture := preload("res://assets/visual/menu/red_x_128.png")

var item_ref:Dictionary = {}
var elapsed_craft_time:float = 0.0
var available:bool = true


func reset():
	available = true
	progress_bar.value = 0
	elapsed_craft_time = 0
	info_display.text = INFO_FORMAT_STRING % ["NULL", 0, 0]
	icon_display.set_icon(null)
	$Timer.stop()


func start_new_sequence(item:String):
	available = false
	item_ref = CraftOpt.fabricator_items[item]
	info_display.text = INFO_FORMAT_STRING % [item_ref.name, item_ref.craft_cost, item_ref.craft_time]
	icon_display.set_icon(load(item_ref.icon))
	$Timer.start()


# Fills the progress bar and checks if the crafting operation should be finished
func update_progress():
	progress_bar.value = roundi((elapsed_craft_time / item_ref["craft_time"]) * PROGRESS_BAR_SEGMENTS)
	if elapsed_craft_time >= item_ref["craft_time"]:
		$Timer.stop()
		on_craft_complete()
		reset()
		emit_signal("craft_complete")


# Handles the actual result of crafting an item
func on_craft_complete():
	match item_ref["id"]:
		"drone":
			Global.drone_manager.increment_max_drones(1)
		"health":
			Global.game_manager.modify_health(1)
		"mod":
			Global.mod_manager.generate_rand_enhancement()
		_:
			print_debug("ERROR: <", item_ref, "> was not able to be crafted")
	
	Logger.create(self, "fabrication", str(item_ref["id"] + " fabricated"))


# Setter function to change the label in the bottom left
func set_core_number(value:int):
	core_number = value
	$MarginContainer/HBoxContainer/LeftVBox/LabelMargins/CoreNumLabel.text = "C" + str(value)


# Advances the craft by whatever the Timer's wait_time is
func _on_timer_timeout():
	elapsed_craft_time += $Timer.get_wait_time()
	update_progress()
