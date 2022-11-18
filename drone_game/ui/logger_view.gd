extends MarginContainer

onready var message_container:VBoxContainer = $MarginContainer/ScrollContainer/MessageContainer


func _ready():
	var _ok = Logger.connect("message_created", self, "add_new_msg")
	_ok = Logger.connect("messages_cleared", self, "clear_messages")

# Creates a new label and adds it to the message container
func add_new_msg(_sender:Node, _type:String, contents:String):
	var msg_label:Label = Label.new()
	msg_label.autowrap = true

	msg_label.text = contents
	message_container.add_child(msg_label)


# Removes all current messages in the logger view
func clear_messages():
	for child in message_container.get_children():
		child.queue_free()
