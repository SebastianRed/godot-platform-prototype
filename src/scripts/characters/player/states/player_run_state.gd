class_name PlayerRunState extends State

const SPEED = 200.0
const ACCELERATION = 800.0
const BRAKING_POWER = 2000.0

func enter() -> void:
	if character_context:
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("run")
		print("PlayerRunState: Entrando")

func physics_process(delta: float) -> void:
	if character_context:
		if not character_context.is_on_floor():
			transition_to("PlayerFallState")
		
		# Nuevo: Transición si el buffer está activo.
		if character_context.jump_buffer_timer > 0 and character_context.is_on_floor():
			character_context.jump_buffer_timer = 0 # Resetear el buffer
			transition_to("PlayerJumpState")
		
		var direction = Input.get_axis("move_left", "move_right")
		var target_velocity = direction * SPEED

		var is_changing_direction = sign(character_context.velocity.x) != sign(direction) and direction != 0
		
		if is_changing_direction:
			character_context.velocity.x = move_toward(character_context.velocity.x, target_velocity, BRAKING_POWER * delta)
		else:
			character_context.velocity.x = move_toward(character_context.velocity.x, target_velocity, ACCELERATION * delta)
		
		if direction:
			var animated_sprite = character_context.get_node("AnimatedSprite2D")
			if animated_sprite:
				animated_sprite.flip_h = direction < 0
		else:
			transition_to("PlayerIdleState")
		
		# Nota: se elimina la condición de `Input.is_action_just_pressed("jump")`
		# porque ahora el buffer se encarga de esa lógica.
		
		character_context.velocity.y += 980 * delta
		character_context.move_and_slide()