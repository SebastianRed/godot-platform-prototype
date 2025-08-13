class_name PlayerFallState
extends State

func enter() -> void:
	play_animation("fall")
	print("PlayerFallState: Entrando, jugador cayendo.")

func physics_process(delta: float) -> void:
	if not character_context:
		return

	character_context.velocity.y += character_context.gravity * delta * 1.8
	var direction = get_input_direction()
	character_context.velocity.x = direction * character_context.speed * 0.8
	flip_sprite_by_direction(direction)

	if character_context.is_on_floor():
		transition_to("PlayerLandState")
		return
	elif Input.is_action_just_pressed("jump") and character_context.current_jumps < character_context.max_jumps:
		transition_to("PlayerJumpState")
		return
	
	character_context.move_and_slide()

func exit() -> void:
	# No hay señales conectadas aquí
	pass