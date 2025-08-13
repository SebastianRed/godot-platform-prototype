class_name PlayerJumpState
extends State

func enter() -> void:
	if character_context:
		if character_context.is_on_floor() or character_context.current_jumps == 0:
			if character_context.try_jump():
				play_animation("jump")
				print("PlayerJumpState: Primer salto iniciado.")
		elif character_context.current_jumps < character_context.max_jumps:
			transition_to("PlayerAirSpinState")
	
func physics_process(delta: float) -> void:
	if not character_context:
		return

	character_context.velocity.y += 980 * delta * 1.2
	var direction = get_input_direction()
	character_context.velocity.x = direction * character_context.speed * 0.7
	flip_sprite_by_direction(direction)
	character_context.move_and_slide()

	if character_context.is_on_floor():
		transition_to("PlayerLandState")
	elif Input.is_action_just_pressed("jump") and character_context.current_jumps < character_context.max_jumps:
		transition_to("PlayerAirSpinState")
	elif character_context.velocity.y > 0:
		transition_to("PlayerFallState")

func exit() -> void:
	pass