class_name EnemyManager
extends Node

@onready var playtime_clock := $"../PlayTimeClock"
@onready var spawn_clock := $EnemySpawnClock
@onready var rng:RandomNumberGenerator = RandomNumberGenerator.new()

var difficulty:int = 0


func _ready():
	Global.enemy_manager = self
	await get_tree().root.ready
	var _ok := playtime_clock.connect("timeout",Callable(self,"calculate_difficulty"))


# Sets the difficulty
func calculate_difficulty():
	var playtime:int = Global.game_manager.get_playtime()
	difficulty = floor(playtime/5)
#	print("DIFF: ", difficulty)


# Turns the spawn clock on or off
func toggle_spawning(state:bool):
	if state:
		spawn_clock.start()
	else:
		spawn_clock.stop()


# Spawns a wave of enemies based on current difficulty
func spawn_wave():
	match difficulty:
		0, 1:
			spawn_slugs(1, 3, 30, 1)
		3:
			spawn_slugs(2, 3, 30, 1)
		_:
			spawn_slugs(3, 3, 30, 1)


# Spawns a pack of slug enemies
func spawn_slugs(count, health, speed, damage):
	Global.gameboard.set_enemy("res://lifeforms/slug.tscn", count, health, speed, damage)
#	Global.level_manager.spawn_enemy("res://lifeforms/slug.tscn", count, health, speed, damage)
#	print("Spawn Slugs: ", count, ", ", speed, ", ", health)


func _on_EnemySpawnClock_timeout():
	spawn_wave()
	var delay:int = rng.randi_range(2, 5)
	spawn_clock.start(delay)
