class_name PlayerIdleState extends State

const DECELERATION = 1600.0

func enter() -> void:
	if character_context:
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("idle")
		print("PlayerIdleState: Entrando.")

func physics_process(delta: float) -> void:
	if character_context:
		if not character_context.is_on_floor():
			transition_to("PlayerFallState")
		else:
			# Nuevo: Transición si el buffer está activo.
			if character_context.jump_buffer_timer > 0:
				character_context.jump_buffer_timer = 0 # Resetear el buffer
				transition_to("PlayerJumpState")
			elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				transition_to("PlayerRunState")
			else:
				character_context.velocity.x = move_toward(character_context.velocity.x, 0, DECELERATION * delta)
				character_context.move_and_slide()