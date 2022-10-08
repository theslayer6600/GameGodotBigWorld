extends Node

var location_of_set = 0
var player_location = 0
var load_x_min = 0
var load_y_min = 0
var load_x_max = 0
var load_y_max = 0

func _process(delta):
	print(location_of_set)
	Player.load_x_min = load_x_min
	Player.load_x_max = load_x_max
	Player.load_y_min = load_y_min
	Player.load_y_max = load_y_max
