extends CharacterBody2D


# Adjust this to influence how quickly the player slows down while on the ground
const FRICTION = 10.0
# Adjust this to increase or decrease the strength of the flick release
const FLICK_POWER := 600.0
# This should be relatively the same size as half the width of the sprite
# A neat trick you can use is to make this bigger to give the player a bit more forgiveness,
# which works especially well on smaller screens.
const CLICK_THRESHOLD := 64.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
# This flag will indicate that we have tapped the character and are currently dragging on the screen
var is_dragging: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and (event.global_position - global_position).length() < CLICK_THRESHOLD:
			# This captures the "click" or "touch" step, meaning this will fire once the character is touched
			# The mouse event will fire regardless of whether the cursor is inside the bounding box of the character,
			# so we will add a check to see if the mouse position is close enough to the character's size.
			# In this case, it will act like a radius.
			print("Touched")
			is_dragging = true
		elif is_dragging:
			# To release the flick, we will check to see if we were dragging to begin with,
			# and that we have released the left mouse button (or released our finger)
			print("Released")
			is_dragging = false
			if (event.global_position - global_position).length() > CLICK_THRESHOLD:
				# We want to check that our final cursor position is outside the player's collision area
				# because we would otherwise have unpredictable angles and it would feel unintuitive.
				# This also gives us the benefit of responding differently to a tap instead of a flick
				# Flick launch code will go here
				print("Flick!")
				var flick_vector: Vector2 = (event.global_position - global_position)
				velocity = flick_vector.normalized() * FLICK_POWER
			else:
				# In the case we release while inside the player's collision area, we will handle it
				# like it was just a tap.
				print("Just a tap")

func _physics_process(delta: float) -> void:
	if is_dragging:
		# If you want to do anything while dragging, put that code here
		print("Dragging")

	# Add the gravity (code unrelated to the flick mechanic, but here to give the player motion)
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	move_and_slide()
