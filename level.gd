extends Node

enum Colors { GREEN, YELLOW, BLUE, RED }

const levels = ["main.tscn"]

var current_level := 0
var buddies: Array = []

func _init():
	for i in len(levels):
		var b = []
		for j in len(Colors):
			b.append(false)
		buddies.append(b)

func get_buddy(color: Colors):
	buddies[current_level][color] = true

func is_buddy_collected(color: Colors):
	return buddies[current_level][color]
