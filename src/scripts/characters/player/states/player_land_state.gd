class_name PlayerLandState extends State

func enter() -> void:
	if character_context:
		# character_context.velocity.x = move_toward(character_context.velocity.x, 0, 2000 * get_process_delta_time())
		character_context.velocity.x = 0
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite:
			animated_sprite.play("land")
			# Conecta la señal `animation_finished` a la nueva función `_on_animation_finished`.
			animated_sprite.animation_finished.connect(_on_animation_finished)
		print("PlayerLandState: Entrando. El jugador ha aterrizado. Animación de aterrizaje en curso...")

func physics_process(delta: float) -> void:
	if character_context:
		# Se aplica gravedad, pero la velocidad horizontal se mantiene en 0 para evitar el movimiento.
		character_context.velocity.y += 980 * delta
		character_context.move_and_slide()

# Esta función se llama automáticamente cuando la animación "land" termina.
func _on_animation_finished() -> void:
	print("PlayerLandState: Animación terminada. Transicionando...")
	if character_context:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			transition_to("PlayerRunState")
		else:
			transition_to("PlayerIdleState")

func exit() -> void:
	# Es buena práctica desconectar la señal para evitar que se llame de forma no intencionada
	# en otros estados.
	if character_context:
		var animated_sprite = character_context.get_node("AnimatedSprite2D")
		if animated_sprite and animated_sprite.animation_finished.is_connected(_on_animation_finished):
			animated_sprite.animation_finished.disconnect(_on_animation_finished)