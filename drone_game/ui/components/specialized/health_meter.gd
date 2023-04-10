class_name HealthMeter
extends PanelContainer

@onready var meter := $MarginContainer/VBoxContainer/Meter
@onready var curr_hp_label := $MarginContainer/VBoxContainer/HealthDisplay/CurrHpDisplay
@onready var max_hp_label := $MarginContainer/VBoxContainer/HealthDisplay/MaxHpDisplay


func _ready():
	await get_tree().root.ready
	var _ok = Global.game_manager.connect("health_changed", health_changed)


# Updates the curr/max health labels and then the meter
func health_changed(curr_hp:int, max_hp:int):
	curr_hp_label.set_value(curr_hp)
	max_hp_label.set_value(max_hp)
	meter.set_pivot(curr_hp, max_hp)
