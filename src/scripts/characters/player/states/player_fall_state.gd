class_name PlayerFallState extends State

func enter() -> void:
	if character_context:
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("fall")
		print("PlayerFallState: Entrando. El jugador está cayendo.")

func physics_process(delta: float) -> void:
	if character_context:
		character_context.velocity.y += 980 * delta * 1.5
		var direction = Input.get_axis("move_left", "move_right")
		character_context.velocity.x = direction * character_context.speed
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite and direction:
			animated_sprite.flip_h = direction < 0
		character_context.move_and_slide()

		# Lógica de transición a Land
		if character_context.is_on_floor():
			transition_to("PlayerLandState")
		
		# Nuevo: Lógica de salto con Coyote Time y Jump Buffering
		# Se permite saltar si:
		# 1) El buffer de salto está activo.
		# Y 2) El temporizador de Coyote Time está activo (primer salto)
		#     O el jugador aún tiene saltos disponibles (doble salto)
		if character_context.jump_buffer_timer > 0:
			if character_context.coyote_timer > 0 and character_context.current_jumps == 0:
				character_context.jump_buffer_timer = 0
				character_context.coyote_timer = 0
				transition_to("PlayerJumpState")
			elif character_context.current_jumps < character_context.max_jumps:
				character_context.jump_buffer_timer = 0
				transition_to("PlayerAirSpinState")