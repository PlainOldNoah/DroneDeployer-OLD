extends Button

signal left_click
signal right_click

onready var item_icon:TextureRect = $MarginContainer/HBoxContainer/TextureRect
onready var item_text:Label = $MarginContainer/HBoxContainer/Label

var ref_item:String = ""
var item_details:Dictionary
var craftable = true


func _ready():
	var _ok := connect("gui_input", self, "_on_CraftQueueItem_gui_input")


# Sets up the label with the necessary information
func initialize(item:String, temp_id:int):
	ref_item = item
	item_details = CraftOpt.fabricator_items[ref_item]
	item_text.text = item_details.name + ": " + str(temp_id)
	item_icon.texture = load(item_details.icon)


# Modified function to handle both left and right clicking
func _on_CraftQueueItem_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("left_click", self)
			BUTTON_RIGHT:
				emit_signal("right_click", self)
