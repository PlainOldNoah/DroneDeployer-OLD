tool
extends Control

export var columns:int = 1 setget set_columns

onready var grid:GridContainer = $ContentContainer/ScrollContainer/GridContainer


func set_columns(value:int):
	columns = value
	$ContentContainer/ScrollContainer/GridContainer.columns = value


func get_children() -> Array:
	return grid.get_children()


func add_child(node: Node, legible_unique_name: bool = false):
	grid.add_child(node, legible_unique_name)
	node.set_owner(self)


func get_child(idx: int) -> Node:
	return grid.get_child(idx)
