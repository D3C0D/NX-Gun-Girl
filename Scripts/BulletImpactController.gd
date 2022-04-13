extends AnimatedSprite



func _on_BulletImpact_animation_finished():
	queue_free()
