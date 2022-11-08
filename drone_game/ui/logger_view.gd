extends Control

onready var message_container:VBoxContainer = $MarginContainer/ScrollContainer/MessageContainer


func _ready():
	var _ok = Logger.connect("message_created", self, "add_new_msg")


# Creates a new label and adds it to the message container
func add_new_msg(message:String):
	var msg_label:Label = Label.new()
	msg_label.autowrap = true

	msg_label.text = message
	message_container.add_child(msg_label)
