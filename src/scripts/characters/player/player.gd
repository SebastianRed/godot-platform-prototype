extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var air_spin_velocity: float = -300.0
@export var max_jumps: int = 2

# Física / ajustes
@export var gravity: float = 980.0
@export var max_fall_speed: float = 500.0

# Timers (buffer / coyote)
@export var jump_buffer_duration: float = 0.2
@export var coyote_time_duration: float = 0.14

var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0

# FSM
var state_machine: StateMachine = null

# Estado de saltos
var current_jumps: int = 0

func _ready() -> void:
	# Referencia a la FSM y entrega del contexto
	state_machine = $StateMachine as StateMachine
	if state_machine:
		state_machine.set_character_context(self)
		print("Player: StateMachine encontrada y contexto establecido.")
	else:
		push_error("Player: StateMachine (nodo 'StateMachine') no encontrada como hijo.")

	# Nos aseguramos de recibir _input
	set_process_input(true)

func _physics_process(delta: float) -> void:
	# Si estamos en suelo, restauramos coyote y reseteamos saltos
	if is_on_floor() and abs(velocity.y) < 10:
		coyote_timer = coyote_time_duration
		current_jumps = 0
	else:
		coyote_timer = max(0.0, coyote_timer - delta)

	# Actualizar timers
	if jump_buffer_timer > 0:
		jump_buffer_timer = max(0.0, jump_buffer_timer - delta)

	# Limitar velocidad de caída
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	# Nota: la lógica de movimiento (aplicar gravity, move_and_slide, transiciones)
	# se realiza dentro de los estados para mantener la FSM coherente.

func _input(event: InputEvent) -> void:
	# Captura de input para jump (buffer)
	if event.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer_duration

	# Reenviamos el evento al state machine para que los estados reaccionen
	if state_machine:
		state_machine._input(event)  # usar el método interno para forzar propagación

# Intenta ejecutar el salto (devuelve true si se ejecutó)
func try_jump() -> bool:
	if is_on_floor() or coyote_timer > 0.0 :
		current_jumps += 1
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		print("Player: try_jump -> salto ejecutado. current_jumps=", current_jumps)
		return true
	elif current_jumps == 1:
		current_jumps += 1
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		print("Player: try_jump -> salto especial ejecutado. current_jumps=", current_jumps)
		return true
	return false

# Helper: consulta si técnicamente hay posibilidad de saltar (sin consumir)
func can_jump() -> bool:
	return is_on_floor() or coyote_timer > 0.0 or current_jumps < max_jumps

# Útiles para debugging rápidos
func _debug_print_state() -> void:
	if state_machine and state_machine.current_state:
		print("Player estado:", state_machine.current_state.name, "vel:", velocity, "jumps:", current_jumps)