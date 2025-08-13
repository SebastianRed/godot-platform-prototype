class_name PlayerLandState
extends State

func enter() -> void:
	if character_context:
		character_context.velocity.x = 0
	play_animation("land", true, "_on_animation_finished")
	print("PlayerLandState: Entrando, animación de aterrizaje.")

func physics_process(delta: float) -> void:
	if character_context:
		character_context.velocity.y += 980 * delta
		character_context.move_and_slide()

func _on_animation_finished() -> void:
	print("PlayerLandState: Animación terminada.")
	if not character_context:
		return

	var direction = get_input_direction()
	if direction != 0:
		transition_to("PlayerRunState")
	else:
		transition_to("PlayerIdleState")

func exit() -> void:
	stop_animation_signal("_on_animation_finished")