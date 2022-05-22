extends Area2D

# Sets default movement size for the player
var grid_size = 64
# Sets state of player
var state = "idle"
# Sets the speed to interpolate between positions
export var interpolation_speed = 3

# Signals
signal player_die()

# Basic player variables
export var player_damage = 1
export var player_bullets = 6
export var max_ammo = 12
export var player_health = 3
export var max_player_health = 3


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
# Gets reference for the no amo sound
onready var no_amo_sound = $NoAmoSound
# Gets reference for the player hurt
onready var player_hurt_sound = $PlayerHurtSound
# Gets reference for the player ammo up
onready var ammo_up_sound = $AmmoUpSound
# Gets reference for the HUD
onready var hud = get_parent().get_node("HUD")

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
	hud.display_bullet_count(player_bullets)

func _process(_delta):
	# Check player health
	if player_health <= 0:
		player_die()
	
	# Check to see if we need to execute any code
	if tween.is_active() or state == "shooting":
		return
	
	# Aling player to the lane
	alig_to_lane()
	
	# Check for inputs and react
	for dir in inputs:
		if Input.is_action_pressed(dir):
			move(dir)
			updateSprite(dir)
	if Input.is_action_pressed("player_shoot_left"):
		shoot("player_move_left")
	elif Input.is_action_pressed("player_shoot_right"):
		shoot("player_move_right")

func updateSprite(dir):
	animatedSprite.play(state, false)
	if inputs[dir] == inputs["player_move_left"]:
		animatedSprite.flip_h = false
	elif inputs[dir] == inputs["player_move_right"]:
		animatedSprite.flip_h = true

func shoot(dir):
	player_bullets = clamp(player_bullets, 0, max_ammo)
	if player_bullets == 0:
		if !no_amo_sound.is_playing():
			no_amo_sound.play()
		return
	player_bullets -= 1
	hud.display_bullet_count(player_bullets)
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

func add_ammo(ammo_pack_size):
	ammo_up_sound.play()
	player_bullets += ammo_pack_size
	player_bullets = clamp(player_bullets, 0, max_ammo)
	hud.display_bullet_count(player_bullets)

func move_tween(dir):
	tween.interpolate_property(self, "position", position,
	 position + inputs[dir] * grid_size, 1.0 / interpolation_speed, Tween.TRANS_SINE,
	 Tween.EASE_IN_OUT)
	tween.start()

func alig_to_lane():
	if position.y < 32:
		position.y = 32
	elif position.y < 96 and position.y > 32:
		position.y = 96
	elif position.y < 160 and position.y > 96:
		position.y = 160

func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "shooting":
		state = "idle"
		animatedSprite.play("idle", false)


func _on_Player_area_entered(area):
	if !area.is_in_group("enemy"):
		return
	player_hurt_sound.play()
	player_health -= 1
	player_health = clamp(player_health, 0, max_player_health)
	hud.display_health(player_health)
	if position.x - area.position.x < 0: # IF IM LEFT
		move("player_move_left")
	else: # IF IM RIGHT
		move("player_move_right")

func player_die():
	emit_signal("player_die")
