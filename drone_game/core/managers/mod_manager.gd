#class_name ModManager
extends Node

signal enhancement_created()

@onready var rng:RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	rng.randomize()


# Enhancements look like; {"stat":affected_stat, "value":value}
# Creates a new enhancement and adds it to the free enhancement array
func create_enhancement(affected_stat:String, value:float):
	var new_enhance: Dictionary = {"stat":affected_stat, "value":value}
	
	emit_signal("enhancement_created", new_enhance)


func generate_rand_enhancement():
	#1. Get the weight total for all enhancements
	var weight_arr:Array = [0]
	for i in CraftOpt.enhancements.values():
		weight_arr.append((weight_arr.back()) + i["weight"])
	
	#2. Generate random enhancement from dict
	var rand_int:int = rng.randi_range(1, weight_arr.back() - 1)
	var selected_enhancement:String = ""
	for i in weight_arr.size():
		if rand_int >= weight_arr[i] and rand_int < weight_arr[i + 1]:
			selected_enhancement = CraftOpt.enhancements.keys()[i]
			break
	
	#3. Get the weight total for all enhancement tiers
	weight_arr = [0]
	for i in CraftOpt.enhancements[selected_enhancement]["tiers"].values():
		weight_arr.append((weight_arr.back()) + i["weight"])
	
	#4. Select random tier of enhancement
	rand_int = rng.randi_range(1, weight_arr.back() - 1)
	var selected_tier:int = 0
	for i in weight_arr.size():
		if rand_int >= weight_arr[i] and rand_int < weight_arr[i + 1]:
			selected_tier = i
			break
	
	#5. Finialize enhancement values
	var roll_bounds:Array = CraftOpt.enhancements[selected_enhancement]["tiers"].values()[selected_tier]["values"]
	var enhancement_value:int = rng.randi_range(roll_bounds.front(), roll_bounds.back())
	print(selected_enhancement, " @ T", selected_tier+1, " with value ", enhancement_value)
	create_enhancement(selected_enhancement, enhancement_value)
#	return selected_enhancement
