extends LineEdit

var ref_item:String = ""
var item_details:Dictionary
var craftable = true

# Sets up the label with the necessary information
func initialize(item:String, temp_id:int):
	ref_item = item
	item_details = Global.crafting_options[ref_item]
	text = item_details.name + ": " + str(temp_id)
	right_icon = load(item_details.icon)
