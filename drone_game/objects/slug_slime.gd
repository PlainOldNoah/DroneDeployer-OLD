extends Area2D

@onready var sprite := $Sprite2D

var placer:Node = null
var size:int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	add_to_group("DEBRIS")


func variate_texture():
	sprite.frame = rng.randi_range(0, sprite.hframes - 1)
