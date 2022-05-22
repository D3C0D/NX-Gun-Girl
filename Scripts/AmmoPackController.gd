extends Area2D

var ammo_size = 12
onready var out_of_mind = $OutOfMind

func _on_AmmoPack_area_entered(area):
	if area.is_in_group("Player"):
		area.add_ammo(ammo_size)
		queue_free()

func _on_VisibilityNotifier2D_viewport_entered(viewport):
	out_of_mind.stop()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	out_of_mind.start()

func _on_OutOfMind_timeout():
	queue_free()
