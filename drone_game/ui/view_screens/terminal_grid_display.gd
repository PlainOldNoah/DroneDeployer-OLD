tool
extends Control

export var columns:int = 1 setget set_columns
export var rows:int = 1
export var populate_with:PackedScene
onready var grid := $ContentContainer/GridContainer


func set_columns(value:int):
	columns = value
	$ContentContainer/GridContainer.columns = value


# Returns the children of the GridContainer
func get_items() -> Array:
	return grid.get_children()


# OVERRIDE: added children should go to the GridContainer instead of local root
func add_child(node: Node, legible_unique_name: bool = false):
	grid.add_child(node, legible_unique_name)
	node.set_owner(self)


# OVERRIDE: Use GridContainer as technical main
func get_child(idx: int) -> Node:
	return grid.get_child(idx)
