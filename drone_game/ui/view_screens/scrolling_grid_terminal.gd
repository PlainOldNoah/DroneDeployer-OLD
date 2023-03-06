@tool
extends Control

@export var columns:int = 1 : set = set_columns

@onready var grid:GridContainer = $ContentContainer/ScrollContainer/GridContainer


func set_columns(value:int):
	columns = value
	$ContentContainer/ScrollContainer/GridContainer.columns = value


func get_items() -> Array[Node]:
	return grid.get_children()


func add_item(node: Node):
	grid.add_child(node)
	node.set_owner(self)


func get_item(idx: int) -> Node:
	return grid.get_child(idx)
