extends CanvasLayer

# Reference to the score label
onready var score_label = $ScoreBox/Score
# Reference to the bullet count
onready var bullet_label = $BulletCounter/HSplitContainer/BulletCount
# Reference to hearts
onready var health_display = [
	$HealthDisplay/HeartboxContainer/Heart1,
	$HealthDisplay/HeartboxContainer/Heart2,
	$HealthDisplay/HeartboxContainer/Heart3
]

func _ready():
	display_score(0)

func display_score(score):
	score_label.text = "Score:" + String(score)

func display_bullet_count(bullets):
	bullet_label.text = String(bullets)

func display_health(health):
	if health == 3:
		health_display[0].visible = true
		health_display[1].visible = true
		health_display[2].visible = true
	elif health == 2:
		health_display[0].visible = false
		health_display[1].visible = true
		health_display[2].visible = true
	elif health == 1:
		health_display[0].visible = false
		health_display[1].visible = false
		health_display[2].visible = true
	elif health == 0:
		health_display[0].visible = false
		health_display[1].visible = false
		health_display[2].visible = false
