extends Node2D

func _process(delta):
	global_position = Vector2(stepify(Player.player_location.x - 128, 256), stepify(Player.player_location.y - 128, 256))
	Player.load_x_min = global_position.x / 32
	Player.load_y_min = global_position.y / 32

func _on_Timer_timeout():
	pass
