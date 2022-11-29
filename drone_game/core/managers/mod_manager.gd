extends Node

signal enhancement_created()

#var free_enhancements := []


func _ready():
	Global.mod_manager = self

# Enhancements look like; {"stat":affected_stat, "value":value}
# Creates a new enhancement and adds it to the free enhancement array
func create_enhancement(affected_stat:String, value:float):
	# Filter out bad inputs
	var new_enhance: Dictionary = {"stat":affected_stat, "value":value}
	
#	free_enhancements.append(new_enhance)
	emit_signal("enhancement_created", new_enhance)
