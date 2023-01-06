extends Node

const GROUP_LIST:Array = [
	"ENEMY","PLAYER",
	"HUB","DRONE","SLUG",
	"EXP"
	]


func add_to_groups(caller:Node, groups:Array):
	for group in groups:
		if GROUP_LIST.has(group):
			caller.add_to_group(group)
		else:
			print_debug("ERROR: <", group, "> DOES NOT EXIST")
