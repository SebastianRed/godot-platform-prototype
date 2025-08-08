extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -350.0
@export var air_spin_velocity: float = -300.0
@export var max_jumps: int = 2

const JUMP_BUFFER_DURATION = 0.15
var jump_buffer_timer: float = 0.0

# Nuevo: constante y variable para el Coyote Time
const COYOTE_TIME_DURATION = 0.15 # Duración en segundos
var coyote_timer: float = 0.0

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
	jump_buffer_timer = max(0, jump_buffer_timer - delta)
	
	# Nuevo: Lógica del temporizador de Coyote Time
	if is_on_floor():
		coyote_timer = COYOTE_TIME_DURATION
		current_jumps = 0
	else:
		coyote_timer = max(0, coyote_timer - delta)

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_DURATION
	if state_machine:
		state_machine._input(event)

func try_jump() -> void:
	if current_jumps < max_jumps:
		current_jumps += 1
		if current_jumps == 1:
			velocity.y = jump_velocity
		elif current_jumps == 2:
			velocity.y = air_spin_velocity
		print("Saltos realizados: ", current_jumps)