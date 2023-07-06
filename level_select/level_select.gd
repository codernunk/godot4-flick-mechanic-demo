extends Control
class_name LevelSelect

@onready var current_level: LevelIcon = $"1"
var parent_world_select: Node
var move_tween: Tween

func _ready():
	$PlayerIcon.global_position = current_level.global_position

func _input(event):
	if move_tween and move_tween.is_running():
		return
	
	if event.is_action_pressed("ui_left") and current_level.next_level_left:
		current_level = current_level.next_level_left
		tween_icon()
	if event.is_action_pressed("ui_right") and current_level.next_level_right:
		current_level = current_level.next_level_right
		tween_icon()
	if event.is_action_pressed("ui_up") and current_level.next_level_up:
		current_level = current_level.next_level_up
		tween_icon()
	if event.is_action_pressed("ui_down") and current_level.next_level_down:
		current_level = current_level.next_level_down
		tween_icon()
	
	if event.is_action_pressed("ui_accept"):
		if current_level.next_scene_path:
			print(current_level.next_scene_path)
			Functions.load_screen_to_scene(current_level.next_scene_path)

	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().add_child(parent_world_select)
		get_tree().current_scene = parent_world_select
		get_tree().get_root().remove_child(self)

func tween_icon():
	move_tween = get_tree().create_tween()
	move_tween.tween_property($PlayerIcon, "global_position", current_level.global_position, 0.5).set_trans(Tween.TRANS_SINE)
