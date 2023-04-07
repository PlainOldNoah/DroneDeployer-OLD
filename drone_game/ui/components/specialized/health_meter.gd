extends PanelContainer

@onready var meter := $MarginContainer/VBoxContainer/Meter
@onready var curr_hp_label := $MarginContainer/VBoxContainer/HealthDisplay/CurrHpPanel/CurrHealthLabel
@onready var max_hp_label := $MarginContainer/VBoxContainer/HealthDisplay/MaxHpPanel/MaxHealthLabel


func _ready():
	await get_tree().root.ready
	var _ok = Global.game_manager.connect("health_changed", health_changed)


# Updates the curr/max health labels and then the meter
func health_changed(curr_hp:int, max_hp:int):
	curr_hp = clamp(curr_hp, 0, 999)
	max_hp = clamp(max_hp, 0, 999)
	
	curr_hp_label.text = "%03d" % (curr_hp)
	max_hp_label.text = "%03d" % (max_hp)
	
	meter.set_pivot(curr_hp, max_hp)
