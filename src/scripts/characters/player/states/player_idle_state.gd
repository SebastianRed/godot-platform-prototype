class_name PlayerIdleState
extends State

const DECELERATION = 1600.0

func enter() -> void:
	play_animation("idle")
	print("PlayerIdleState: Entrando.")

func physics_process(delta: float) -> void:
	if not character_context:
		return

	if not character_context.is_on_floor():
		transition_to("PlayerFallState")
		return

	if character_context.jump_buffer_timer > 0:
		character_context.jump_buffer_timer = 0
		transition_to("PlayerJumpState")
		return

	var direction = get_input_direction()
	if direction != 0:
		transition_to("PlayerRunState")
		return

	character_context.velocity.x = move_toward(character_context.velocity.x, 0, DECELERATION * delta)
	character_context.move_and_slide()

func exit() -> void:
	# No hay señales conectadas aquí
	pass