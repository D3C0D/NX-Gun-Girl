extends Area2D

# Sets default movement size for the player
var grid_size = 64
# Sets state of player
var state = "idle"
# Sets the speed to interpolate between positions
export var interpolation_speed = 3
export var player_damage = 1

# Gets reference for the raycast after scene loads
onready var ray = $CollisionCheckRay
# Gets reference for the bullet raycast after scene loads
onready var bullet_ray = $BulletRayCast
# Sets bullet ray distance
onready var bullet_distance = get_viewport().size.x / 2
#Gets the reference for the tween to animate the movement
onready var tween = $Tween
# Gets reference for the animation after scene loads
onready var animatedSprite = $AnimatedSprite
# Gets reference for the bullet sound
onready var shootSound = $ShootSound

# Sets reference for bullet hit
onready var bullet_hit_instance = preload("res://Prefabs/Bullet-Impact.tscn")


# Creates dictionary for movement directions
var inputs = {
	"player_move_up": Vector2.UP,
	"player_move_down": Vector2.DOWN,
	"player_move_right": Vector2.RIGHT,
	"player_move_left": Vector2.LEFT
}

func _ready():
	position = position.snapped(Vector2.ONE * grid_size)
	position += Vector2.ONE * grid_size / 2

#func _process(_delta):
#	print(bullet_distance)

func _unhandled_input(event):
	if tween.is_active() or state == "shooting":
		return
	for dir in inputs:
		if event.is_action_pressed(dir):
			move(dir)
			updateSprite(dir)
	if event.is_action_pressed("player_shoot_left"):
		shoot("player_move_left")
	elif event.is_action_pressed("player_shoot_right"):
		shoot("player_move_right")

func updateSprite(dir):
	animatedSprite.play(state, false)
	if inputs[dir] == inputs["player_move_left"]:
		animatedSprite.flip_h = false
	elif inputs[dir] == inputs["player_move_right"]:
		animatedSprite.flip_h = true

func shoot(dir):
	shootSound.play()
	state = "shooting"
	updateSprite(dir)
	bullet_ray.cast_to = inputs[dir] * bullet_distance
	bullet_ray.force_raycast_update()
	if bullet_ray.is_colliding():
		var temp_bullet_impact = bullet_hit_instance.instance()
		temp_bullet_impact.position = bullet_ray.get_collision_point()
		get_tree().get_root().add_child(temp_bullet_impact)
		bullet_ray.get_collider().get_hit(player_damage)

func move(dir):
	ray.cast_to = inputs[dir] * grid_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		move_tween(dir)
#		Old movement code
#		position += inputs[dir] * grid_size

func move_tween(dir):
	tween.interpolate_property(self, "position", position,
	 position + inputs[dir] * grid_size, 1.0 / interpolation_speed, Tween.TRANS_SINE,
	 Tween.EASE_IN_OUT)
	tween.start()


func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "shooting":
		state = "idle"
		animatedSprite.play("idle", false)


func _on_Player_area_entered(area):
	if area.walking_direction == Vector2.LEFT:
		move("player_move_left")
	elif area.walking_direction == Vector2.RIGHT:
		move("player_move_right")
