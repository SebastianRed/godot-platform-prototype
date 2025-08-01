class_name PlayerRunState extends State

const SPEED = 200.0

func enter() -> void:
    if character_context:
        var animated_sprite = character_context.get_node("AnimatedSprite2D")
        if animated_sprite:
            animated_sprite.play("run")
        print("PlayerRunState: Entrando")

func physics_process(delta: float) -> void:
    if character_context:
        if not character_context.is_on_floor():
            character_context.velocity.y += 980 * delta
        var direction = Input.get_axis("move_left", "move_right")
        if direction:
            character_context.velocity.x = direction * SPEED
            var animated_sprite = character_context.get_node("AnimatedSprite2D")
            if animated_sprite:
                animated_sprite.flip_h = direction < 0
        else:
            transition_to("PlayerIdleState")
        if Input.is_action_just_pressed("jump") and character_context.is_on_floor():
            transition_to("PlayerJumpState")
        character_context.move_and_slide()