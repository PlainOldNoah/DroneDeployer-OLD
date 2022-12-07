class_name ModManager
extends Node

signal enhancement_created()

onready var rng:RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	Global.mod_manager = self


# Enhancements look like; {"stat":affected_stat, "value":value}
# Creates a new enhancement and adds it to the free enhancement array
func create_enhancement(affected_stat:String, value:float):
	var new_enhance: Dictionary = {"stat":affected_stat, "value":value}
	
	emit_signal("enhancement_created", new_enhance)


func create_rand_enhancement():
	var keys = GameVars.DEFAULT_ENHANCEMENTS.keys()
	var stat = keys[randi() % keys.size()]
	var value = GameVars.DEFAULT_ENHANCEMENTS[stat]["values"][randi() % GameVars.DEFAULT_ENHANCEMENTS[stat]["values"].size()] 
	
	create_enhancement(stat, value)
