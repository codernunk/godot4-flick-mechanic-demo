extends Control

func _on_button_pressed():
	Functions.load_screen_to_scene("res://main.tscn", {"test": "f"})
