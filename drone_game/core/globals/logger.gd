extends Node

signal message_created() # Recieved by logger_view
signal messages_cleared()

var messages:PoolStringArray = []

# Adds a new message to the logger
func create(sender:Node, type:String, contents:String):
#	messages.append(contents)
	emit_signal("message_created", sender, type, contents)
#	print_msg(message)


# Removes all messages from the logger
func clear():
	messages = []
	emit_signal("messages_cleared")


# Prints out the message as well as what number message it is
func print_msg(message:String):
	print("LOGGER| ", messages.size(), ": ", message)
