tool
extends Control

export var columns:int = 1 setget set_columns

func set_columns(value:int):
	columns = value
	$ContentContainer/GridContainer.columns = value
