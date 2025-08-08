class_name PlayerAirSpinState extends State

func enter() -> void:
	if character_context:
		character_context.try_jump()
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("air_spin")
			animated_sprite.animation_finished.connect(_on_animation_finished)
		print("PlayerAirSpinState: Gira en el aire!")

func physics_process(delta: float) -> void:
	if character_context:
		character_context.velocity.y += 980 * delta
		var direction = Input.get_axis("move_left", "move_right")
		character_context.velocity.x = direction * character_context.speed
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite and direction:
			animated_sprite.flip_h = direction < 0
		character_context.move_and_slide()

func _on_animation_finished() -> void:
	print("PlayerLandState: Animación terminada. Transicionando...")
	if character_context:
		if character_context.is_on_floor():
			transition_to("PlayerLandState")
		elif character_context.velocity.y > 0 and not character_context.is_on_floor():
			transition_to("PlayerFallState")

func exit() -> void:
	if character_context:
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite and animated_sprite.animation_finished.is_connected(_on_animation_finished):
			animated_sprite.animation_finished.disconnect(_on_animation_finished)