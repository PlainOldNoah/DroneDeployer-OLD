extends Control

signal relay_btn_pressed()

var cached_mod:Dictionary = {}


func init(data:Dictionary):
	cached_mod = data
	$TEMP_NAME.text = data.stat + "\n" + str(data.value)
#	name_label.text = data.stat
#	desc_label.text = str(data.value)


func _on_Button_pressed():
	emit_signal("relay_btn_pressed", self)
