extends AnimatedSprite

onready var player = get_parent().get_node("Player")
onready var ammo_instance = preload("res://Prefabs/AmmoPack.tscn")

func _on_Explosion_animation_finished():
	if player.player_bullets <= 4:
		var temp_ammo = ammo_instance.instance()
		temp_ammo.position = position
		get_tree().get_root().get_node("TestWorld").add_child(temp_ammo)
	visible = false


func _on_AudioStreamPlayer2D_finished():
	queue_free()
