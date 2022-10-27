extends Node

signal message_created()

var messages:PoolStringArray = []


# Adds a new message to the logger
func create(message:String):
	messages.append(message)
	emit_signal("message_created", message)
#	print_msg(message)


# Removes all messages from the logger
func clear():
	messages = []


# Prints out the message as well as what number message it is
func print_msg(message:String):
	print("LOGGER| ", messages.size(), ": ", message)
