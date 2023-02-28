extends TextureRect

signal relay_btn_pressed()

onready var popup_window := $CanvasLayer/UIPanel
onready var name_label := $CanvasLayer/UIPanel/MarginContainer/VBoxContainer/NameLabel
onready var desc_label := $CanvasLayer/UIPanel/MarginContainer/VBoxContainer/DescLabel

var cached_mod:Dictionary = {}
var mouse_hovering:bool = false


func _ready():
	toggle_popup(mouse_hovering)
	modulate = Color(randf(), randf(), randf())


func init(data:Dictionary):
	cached_mod = data
	name_label.text = data.stat
	desc_label.text = str(data.value)


func reset():
	toggle_popup(false)
	cached_mod = {}
	name_label.text = ""
	desc_label.text = ""


func _process(_delta):
	popup_window.rect_global_position = get_global_mouse_position() + Vector2(0, 8)


# Enables or disables the popup window
func toggle_popup(state:bool):
	mouse_hovering = state
	popup_window.visible = state
	set_process(state)


func _on_ModDisplay_mouse_entered():
	toggle_popup(true)


func _on_ModDisplay_mouse_exited():
	toggle_popup(false)


func _on_Button_pressed():
	emit_signal("relay_btn_pressed", self)
