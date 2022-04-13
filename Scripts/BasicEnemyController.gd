extends Area2D

# Sets default grid size
var grid_size = 64

# Get reference for the animated sprite to flip it in case of needing
onready var animatedSprite = $AnimatedSprite
onready var explosion_instance = preload("res://Prefabs/Explosion.tscn")

# Set direction for the enemy to walk lol
export var walking_direction = Vector2.LEFT
# Basic variables for the enemy
export var enemy_health = 3
export var enemy_speed = 3

func _ready():
	# Init the direction
	init()

func _process(delta):
	# Check enemy health to die
	if enemy_health > 0:
		move(delta)
	else:
		die()

func move(delta):
	position += walking_direction * enemy_speed * delta

func die():
	var temp_explosion = explosion_instance.instance()
	temp_explosion.position = position
	get_tree().get_root().add_child(temp_explosion)
	queue_free()

func get_hit(damage):
	enemy_health -= damage

func init():
	if walking_direction != Vector2.LEFT:
		animatedSprite.flip_h = !animatedSprite.flip_h
