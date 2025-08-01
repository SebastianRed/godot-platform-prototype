class_name PlayerIdleState extends State

func enter() -> void:
	if character_context:
		character_context.velocity.x = 0
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("idle")
		print("PlayerIdleState: Entrando. Velocity X: ", character_context.velocity.x)

func physics_process(delta: float) -> void:
	if character_context:
		if not character_context.is_on_floor():
			character_context.velocity.y += 980 * delta
			character_context.move_and_slide()
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			transition_to("PlayerRunState")
		elif Input.is_action_just_pressed("jump"):
			transition_to("PlayerJumpState")
		else:
			character_context.velocity.x = move_toward(character_context.velocity.x, 0, 500 * delta)
			character_context.move_and_slide()
