extends Node2D

# Create random lanes
export var spawn_position = [
	Vector2(0, 32),
	Vector2(0, 96),
	Vector2(0, 160)
]

# Create the rng
var rng = RandomNumberGenerator.new()

# Get viewport width
onready var viewport_width = get_viewport_rect().size.x

# Get player reference
onready var player_node = get_parent().get_node("Player")

# Get an array of posible enemies
onready var enemy_instances = [
	preload("res://Prefabs/Bipedal-Unit.tscn")
	]

func _process(_delta):
	position = player_node.position

func _on_EnemySpawnTimer_timeout():
	var temp_position = spawn_position[rng.randi_range(0, 2)]
	var temp_enemy = enemy_instances[rng.randi_range(0, enemy_instances.size() - 1)].instance()
	
	var temp_side = rng.randi_range(0, 1)
	if temp_side == 0: # Spawn from right to left
		temp_position.x = position.x + viewport_width / 2
		temp_enemy.walking_direction = Vector2.LEFT
	elif temp_side == 1: # Spawn from left to right
		temp_position.x = position.x - viewport_width / 2
		temp_enemy.walking_direction = Vector2.RIGHT
	
	temp_enemy.position = temp_position
	get_tree().get_root().add_child(temp_enemy)
