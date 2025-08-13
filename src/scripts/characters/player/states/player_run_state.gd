class_name PlayerRunState
extends State

const SPEED = 200.0
const ACCELERATION = 800.0
const BRAKING_POWER = 2000.0

func enter() -> void:
	play_animation("run")
	print("PlayerRunState: Entrando.")

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
	var target_velocity = direction * SPEED

	var is_changing_direction = sign(character_context.velocity.x) != sign(direction) and direction != 0
	var acceleration = BRAKING_POWER if is_changing_direction else ACCELERATION

	character_context.velocity.x = move_toward(character_context.velocity.x, target_velocity, acceleration * delta)
	flip_sprite_by_direction(direction)

	if direction == 0:
		transition_to("PlayerIdleState")
		return

	character_context.velocity.y += 980 * delta
	character_context.move_and_slide()

func exit() -> void:
	# No hay señales conectadas aquí
	pass