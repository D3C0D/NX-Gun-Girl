extends Control

onready var high_score_label = $HighScoreContainer/HighScore

func _ready():
	var temp_high_score = load_high_score()
	if temp_high_score == 0:
		high_score_label.text = ""
	else:
		high_score_label.text = "Highest Score: " + String(temp_high_score)

func _input(event):
	if event.is_action_pressed("ui_plus"):
		get_tree().change_scene("res://Scenes/TestWorld.tscn")
	elif event.is_action_pressed("ui_minus"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")

func load_high_score():
	var temp_high_score = 0
	var file = File.new()
	if file.file_exists("user://d3c0d.dat"):
		file.open("user://d3c0d.dat", File.READ)
		temp_high_score = file.get_var()
	file.close()
	return int(temp_high_score)
