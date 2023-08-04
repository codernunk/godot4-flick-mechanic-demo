extends Area2D
class_name Buddy

@export var color: Level.Colors

func _ready():
	if Level.is_buddy_collected(color):
		$AnimationPlayer.play("Active")
		$CollisionShape2D.set_deferred("disabled", true)

func _on_body_entered(body):
	$AnimationPlayer.play("Get")
	$CollisionShape2D.set_deferred("disabled", true)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Get":
		Level.get_buddy(color)
		$AnimationPlayer.play("Active")
