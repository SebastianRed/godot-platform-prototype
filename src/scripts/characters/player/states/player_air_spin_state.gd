class_name PlayerAirSpinState
extends State

func enter() -> void:
	if character_context:
		character_context.try_jump()
		play_animation("air_spin", true, "_on_animation_finished")
		print("PlayerAirSpinState: Gira en el aire.")

func physics_process(delta: float) -> void:
	if not character_context:
		return
	character_context.velocity.y += character_context.gravity * delta * 1.5
	var direction = get_input_direction()
	character_context.velocity.x = direction * character_context.speed * 0.6
	flip_sprite_by_direction(direction)
	character_context.move_and_slide()

func _on_animation_finished() -> void:
	if not character_context:
		return
	if character_context.is_on_floor():
		transition_to("PlayerLandState")
	elif character_context.velocity.y > 0:
		transition_to("PlayerFallState")

func exit() -> void:
	stop_animation_signal("_on_animation_finished")