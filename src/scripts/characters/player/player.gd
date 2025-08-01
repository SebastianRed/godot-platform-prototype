extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -350.0
@export var double_jump_velocity: float = -300.0
@export var max_jumps: int = 2

var state_machine: StateMachine = null
var current_jumps: int = 0

func _ready() -> void:
    state_machine = $StateMachine as StateMachine
    if state_machine:
        state_machine.set_character_context(self)
        print("Player: StateMachine encontrada y contexto establecido.")
    else:
        push_error("Player: StateMachine (nodo 'StateMachine') no encontrada como hijo.")

func _physics_process(delta: float) -> void:
    if is_on_floor():
        current_jumps = 0

func _process(delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    if state_machine:
        state_machine._input(event)

func try_jump() -> void:
    if current_jumps < max_jumps:
        current_jumps += 1
        if current_jumps == 1:
            velocity.y = jump_velocity
        elif current_jumps == 2:
            velocity.y = double_jump_velocity
        print("Saltos realizados: ", current_jumps)