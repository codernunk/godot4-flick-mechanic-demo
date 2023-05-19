extends CharacterBody2D


# Adjust this to influence how quickly the player slows down while on the ground
const FRICTION = 10.0
const JUMP_POWER: float = 750.0
const GROUND_POUND_FALL_SPEED: float = 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# This indicates if the ground pound motion is active
var is_ground_pound: bool = false

func _physics_process(delta: float) -> void:
	if not is_ground_pound:
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = -JUMP_POWER

		if Input.is_action_just_pressed("ui_down") and not is_on_floor():
			_start_ground_pound()

	# Add the gravity (code unrelated to the flick mechanic, but here to give the player motion)
	if not is_on_floor():
		if not is_ground_pound:
			velocity.y += gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	move_and_slide()
	# Since there could be multiple collisions, we will need to loop through them
	for i in get_slide_collision_count(): _collide(get_slide_collision(i))

# Helps nest the code that handles move and slide collisions
func _collide(collision: KinematicCollision2D):
	if is_on_floor() and is_ground_pound:
		$AnimationPlayer.play("GroundPoundLand")

# This function is called when the player hits the down key while in the air
# It'll initate the ground pound motion and it'll pause the velocity while the startup animation plays
func _start_ground_pound():
	is_ground_pound = true
	velocity = Vector2.ZERO
	$AnimationPlayer.play("GroundPoundInit")

## This is called after the GroundPoundInit animation is finished
## Refer to the AnimationPlayer's function keyframe to see how it works.
func _ground_pound_move():
	velocity = Vector2(0, GROUND_POUND_FALL_SPEED)

## This is called at the end of the GroundPoundLand animation.
## Refer to the AnimationPlayer's function keyframe to see how it works.
func _end_ground_pound():
	is_ground_pound = false
	# Uncomment this code if you want the player to bounce instead of staying put on the ground.
	# I recommend making the magnitude of the bounce a constant if you choose to do this.
	# velocity = Vector2(0, -1000)
