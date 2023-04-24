extends Control

@onready var message_container:VBoxContainer = $ContentContainer/ScrollContainer/MessageContainer


func _ready():
	var _ok = Logger.connect("message_created",Callable(self,"add_new_msg"))
	_ok = Logger.connect("messages_cleared",Callable(self,"clear_messages"))


# Creates a new label and adds it to the message container
func add_new_msg(_sender:Node, _type:String, contents:String):
	var msg_label:Label = Label.new()
	msg_label.set_autowrap_mode(TextServer.AUTOWRAP_WORD)

	msg_label.text = contents
	message_container.add_child(msg_label)
	message_container.move_child(msg_label, 0)


# Removes all current messages in the logger view
func clear_messages():
	for child in message_container.get_children():
		child.queue_free()
