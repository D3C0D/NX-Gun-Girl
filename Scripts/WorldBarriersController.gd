extends StaticBody2D

onready var player_node = get_parent().get_node("Player")
onready var sprite_width = $Sprite.texture.get_width()


func _process(_delta):
	var temp_poss = Vector2(player_node.position.x - sprite_width / 2, position.y)
	position = temp_poss
	
