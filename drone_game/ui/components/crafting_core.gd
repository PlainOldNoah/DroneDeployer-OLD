@tool
extends PanelContainer

#enum STATE {RUNNING, IDLE, PAUSED, STOPPED}
#var state:STATE = STATE.IDLE

const PROGRESS_BAR_SEGMENTS:int = 11
const INFO_FORMAT_STRING:String = "%s\n%d Scrap       %d Sec"

signal core_freed()

@export var core_number:int = 0 : set = set_core_number

@onready var progress_bar := $MarginContainer/HBoxContainer/TextureProgressBar
@onready var info_display := $MarginContainer/HBoxContainer/LeftVBox/PanelContainer/InfoMargin/CoreInfoDisplay
@onready var icon_display := $MarginContainer/HBoxContainer/LeftVBox/SingleIconDisplay
@onready var pause_led := $MarginContainer/HBoxContainer/LeftVBox/LabelMargins/PauseLED
@onready var repeat_led := $MarginContainer/HBoxContainer/LeftVBox/LabelMargins/RepeatLED
@onready var locked_led := $MarginContainer/HBoxContainer/LeftVBox/LabelMargins/LockedLED
@onready var x_texture := preload("res://assets/visual/menu/red_x_128.png")

var item_ref:Dictionary = {}
var elapsed_craft_time:float = 0.0
var available:bool = true

var repeat_sequence:bool = false
var lock_core:bool = false


func _ready():
	await get_tree().root.ready
	var _ok = connect("core_freed", Callable(Global.fabricator,"_on_crafting_core_freed"))
	set_led_colors()


# Set values to defaults, option to keep core unavailable
func reset(unlock_core:bool=true):
	set_available(unlock_core)
	cancel_sequence()


# Sets the core to begin crafting a new item
func start_new_sequence(item:String):
	set_available(false)
	item_ref = CraftOpt.fabricator_items[item]
	info_display.text = INFO_FORMAT_STRING % [item_ref.name, item_ref.craft_cost, item_ref.craft_time]
	icon_display.set_icon(load(item_ref.icon))
	$Timer.start()
	set_led_colors()


# Fills the progress bar and checks if the crafting operation should be finished
func update_progress():
	progress_bar.value = roundi((elapsed_craft_time / item_ref["craft_time"]) * PROGRESS_BAR_SEGMENTS)
	if elapsed_craft_time >= item_ref["craft_time"]:
		$Timer.stop()
		complete_craft_sequence()


# Handles the actual result of crafting an item
func complete_craft_sequence():
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
	
	if lock_core:
		reset(false)
	elif repeat_sequence:
		reset(false)
		start_new_sequence(item_ref.id)
	else:
		reset()
	
	set_led_colors()


func set_available(state:bool):
	available = state
	if available:
		emit_signal("core_freed")


# Setter function to change the label in the bottom left
func set_core_number(value:int):
	core_number = value
	$MarginContainer/HBoxContainer/LeftVBox/LabelMargins/CoreNumLabel.text = "C" + str(value)


func set_led_colors():
	if $Timer.is_paused(): # Timer is paused
		pause_led.set_light_color(Color.YELLOW)
	elif not $Timer.is_stopped(): # Timer is running
		pause_led.set_light_color(Color.GREEN)
	elif lock_core and $Timer.is_stopped(): # Core is locked and timer is not running
		pause_led.set_light_color(Color.RED)
	else: # Timer is off and core is available
		pause_led.set_light_color(Color.GRAY)
	
	
	if repeat_sequence and not lock_core:
		repeat_led.set_light_color(Color.GREEN)
	else:
		repeat_led.set_light_color(Color.RED)
	
	
	if lock_core:
		locked_led.set_light_color(Color.GREEN)
	else:
		locked_led.set_light_color(Color.RED)


# Pauses/resumes the current crafting sequence
func toggle_pause_sequence():
	$Timer.set_paused(not $Timer.is_paused())
	set_led_colors()


# Upon sequence completion automatically start the same sequence
func toggle_sequence_repeat():
	repeat_sequence = not repeat_sequence
	set_led_colors()


# Disallows queued items from using this core
func toggle_lock_core():
	lock_core = not lock_core
	
	if lock_core == false and $Timer.get_time_left() == 0:
		set_available(true)
		repeat_sequence = false
	else:
		set_available(false)
	
	set_led_colors()


# Stops the current sequence and refunds materials
func cancel_sequence():
	$Timer.stop()
	progress_bar.value = 0
	elapsed_craft_time = 0
	info_display.text = INFO_FORMAT_STRING % ["NULL", 0, 0]
	icon_display.set_icon(null)
	set_led_colors()


# Advances the craft by whatever the Timer's wait_time is
func _on_timer_timeout():
	elapsed_craft_time += $Timer.get_wait_time()
	update_progress()
