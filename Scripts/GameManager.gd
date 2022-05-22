extends Node2D

# Game variables
var score = 0
var high_score = 0

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
# Get HUD Reference
onready var hud = get_parent().get_node("HUD")

# Get an array of posible enemies
onready var enemy_instances = [
	preload("res://Prefabs/Bipedal-Unit.tscn"),
	preload("res://Prefabs/Tank-Unit.tscn"),
	preload("res://Prefabs/Spaceship-Unit.tscn")
	]

func _ready():
	high_score = load_high_score()
	rng.randomize()

func _process(_delta):
	position = player_node.position

func update_score(points):
	score += points
	hud.display_score(score)

func save_high_score(new_high):
	var file = File.new()
	file.open("user://d3c0d.dat", File.WRITE)
	file.store_var(new_high)
	file.close()

func load_high_score():
	var temp_high_score = 0
	var file = File.new()
	if file.file_exists("user://d3c0d.dat"):
		file.open("user://d3c0d.dat", File.READ)
		temp_high_score = file.get_var()
	file.close()
	return temp_high_score

func _on_EnemySpawnTimer_timeout():
	if get_tree().get_nodes_in_group("enemy").size() > 10:
		return
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
	get_tree().get_root().get_node("TestWorld").add_child(temp_enemy)


func _on_Player_player_die():
	if high_score < score:
		save_high_score(score)
	get_tree().change_scene("res://Scenes/GameOver.tscn")
