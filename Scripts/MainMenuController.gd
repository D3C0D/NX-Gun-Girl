extends Control

onready var start_label = $PressStartContainer/PressStart
onready var start_blink_timer = $StartBlink

func _input(event):
	if event.is_action_pressed("ui_plus"):
		get_tree().change_scene("res://Scenes/TestWorld.tscn")

func blink_flip():
	start_label.visible = !start_label.visible
