extends Panel

@onready var core_select_dial := $MarginContainer/CraftCoreInnerMargin/CoreControls/CoreSelector/LeftSection/Dial
@onready var craft_core_grid := $MarginContainer/CraftCoreInnerMargin/CraftingCoreGrid

var focused_core:int = 0


func _ready():
	var _ok = core_select_dial.connect("dial_selection_changed", set_focused_core)


func set_focused_core(num:int):
	focused_core = clamp(num, 0, 3)


# Central func for crafting core buttons
func _on_button_pressed(_click_action:String, function:String):
	match function:
		"pause":
			craft_core_grid.get_child(focused_core).toggle_pause_sequence()
		"repeat":
			craft_core_grid.get_child(focused_core).toggle_sequence_repeat()
		"lock":
			craft_core_grid.get_child(focused_core).toggle_lock_core()
		"cancel":
			craft_core_grid.get_child(focused_core).abort_sequence()
		_:
			print_debug("ERROR: <", function, "> is not a valid button function")
			
#	print(function, ": ", focused_core)
