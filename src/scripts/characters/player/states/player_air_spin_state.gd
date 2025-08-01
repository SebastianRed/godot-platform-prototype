class_name PlayerAirSpinState extends State

func enter() -> void:
	if character_context:
		character_context.try_jump()
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("air_spin") 
		print("PlayerAirSpinState: Gira en el aire!")

func physics_process(delta: float) -> void:
	if character_context:
		character_context.velocity.y += 980 * delta
		var direction = Input.get_axis("move_left", "move_right")
		character_context.velocity.x = direction * character_context.speed
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite and direction:
			animated_sprite.flip_h = direction < 0
		character_context.move_and_slide()
		if character_context.is_on_floor():
			if direction:
				transition_to("PlayerRunState")
			else:
				transition_to("PlayerIdleState")
		elif character_context.velocity.y > 0 and not character_context.is_on_floor(): # 
			pass