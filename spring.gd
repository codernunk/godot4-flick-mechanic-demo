extends Area2D

# Use this to tweak the spring power on an individual basis
@export var spring_power: int = 800

func _on_body_entered(body):
	# We need to check that the player is the one who collided with the spring
	if body is Player:
		# Invoke the player's spring method with the spring's direction plus 90 degrees (since the spring is facing upwards by default)
		body.spring(spring_power, rotation + PI/2.0) 
		$AnimationPlayer.play("Spring")
