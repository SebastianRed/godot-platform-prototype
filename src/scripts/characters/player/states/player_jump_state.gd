class_name PlayerJumpState extends State

func enter() -> void:
	if character_context:
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("jump")
		if character_context.is_on_floor() or character_context.current_jumps == 0:
			character_context.try_jump()
			print("PlayerJumpState: Primer Salto Iniciado!")
		else:
			if character_context.current_jumps < character_context.max_jumps:
				transition_to("PlayerAirSpinState")
			else:
				pass

func physics_process(delta: float) -> void:
	if character_context:
		character_context.velocity.y += 980 * delta
		var direction = Input.get_axis("move_left", "move_right")
		character_context.velocity.x = direction * character_context.speed
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite and direction:
			animated_sprite.flip_h = direction < 0
		character_context.move_and_slide()

		# Actualización de transiciones
		if character_context.is_on_floor():
			transition_to("PlayerLandState")
		elif Input.is_action_just_pressed("jump") and character_context.current_jumps < character_context.max_jumps:
			transition_to("PlayerAirSpinState")
		elif character_context.velocity.y > 0 and not character_context.is_on_floor():
			transition_to("PlayerFallState")