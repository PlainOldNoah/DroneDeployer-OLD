extends Control

@onready var icon := $Panel/MarginContainer/HBoxContainer/TextureRect
@onready var name_label := $Panel/MarginContainer/HBoxContainer/NameLabel
@onready var cost_label := $Panel/MarginContainer/HBoxContainer/VBoxContainer/CostLabel
@onready var time_label := $Panel/MarginContainer/HBoxContainer/VBoxContainer/TimeLabel

var item_ref:Dictionary = {}
var available:bool = true


func initialize(item:String):
	available = false
	item_ref = CraftOpt.fabricator_items[item]
	name_label.text = item_ref.name
	cost_label.text = "Cost: " + str(item_ref.craft_cost)
	time_label.text = "Time: " + str(item_ref.craft_time)
	icon.texture = load(item_ref.icon)


func reset():
	available = true
	item_ref = {}
	name_label.text = ""
	cost_label.text = ""
	time_label.text = ""
	icon.texture = null
