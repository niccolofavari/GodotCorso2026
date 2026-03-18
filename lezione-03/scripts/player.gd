extends CharacterBody2D

# === Costanti di movimento ===
const SPEED = 100.0
const JUMP_VELOCITY = -270.0
const JUMP_CUT_FACTOR = 0.4          # Quando rilasci il salto, la velocità Y viene moltiplicata per questo
const ROLL_SPEED = 180.0              # Velocità durante la capriola
const ROLL_DURATION = 0.33            # Durata della capriola (in secondi)

# === Stati possibili ===
enum State { IDLE, RUN, JUMP, ROLL }

# === Variabili ===
var state: State = State.IDLE
var roll_timer: float = 0.0           # Tempo rimanente della capriola
var roll_direction: float = 0.0       # Direzione della capriola (-1 o 1)

# Riferimento all'AnimatedSprite2D (lo prendiamo una volta sola)
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Gravità — si applica sempre, in ogni stato
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Leggiamo la direzione premuta dal giocatore
	var direction := Input.get_axis("ui_left", "ui_right")

	# Flip della sprite quando si preme una direzione
	if direction != 0:
		anim.flip_h = direction < 0

	# === Macchina a stati ===
	match state:
		State.IDLE:
			_state_idle(direction)
		State.RUN:
			_state_run(direction)
		State.JUMP:
			_state_jump(direction)
		State.ROLL:
			_state_roll(delta)

	# Movimento effettivo
	move_and_slide()


# --------------------------------------------------
# IDLE — fermo a terra
# --------------------------------------------------
func _state_idle(direction: float) -> void:
	# Decelerazione fino a fermarsi
	velocity.x = move_toward(velocity.x, 0, SPEED)

	# Transizioni
	if not is_on_floor():
		_change_state(State.JUMP)
		return
	if Input.is_action_just_pressed("ui_accept"):
		_jump()
		return
	if Input.is_action_just_pressed("roll") and direction != 0:
		_start_roll(direction)
		return
	if direction != 0:
		_change_state(State.RUN)
		return


# --------------------------------------------------
# RUN — corsa a terra
# --------------------------------------------------
func _state_run(direction: float) -> void:
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Transizioni
	if not is_on_floor():
		_change_state(State.JUMP)
		return
	if Input.is_action_just_pressed("ui_accept"):
		_jump()
		return
	if Input.is_action_just_pressed("roll") and direction != 0:
		_start_roll(direction)
		return
	if direction == 0 and is_zero_approx(velocity.x):
		_change_state(State.IDLE)
		return


# --------------------------------------------------
# JUMP — in aria (salto o caduta)
# --------------------------------------------------
func _state_jump(direction: float) -> void:
	# Movimento orizzontale in aria
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Variable jump: se rilasci il tasto mentre sali, tagli la velocità
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_CUT_FACTOR

	# Transizione: atterra
	if is_on_floor():
		if direction != 0:
			_change_state(State.RUN)
		else:
			_change_state(State.IDLE)
		return


# --------------------------------------------------
# ROLL — capriola (non si può interrompere)
# --------------------------------------------------
func _state_roll(delta: float) -> void:
	roll_timer -= delta
	velocity.x = roll_direction * ROLL_SPEED

	# Transizione: la capriola è finita
	if roll_timer <= 0.0:
		if not is_on_floor():
			_change_state(State.JUMP)
		elif is_zero_approx(Input.get_axis("ui_left", "ui_right")):
			_change_state(State.IDLE)
		else:
			_change_state(State.RUN)
		return

	# Se cade durante la roll, continua la roll fino alla fine del timer
	# (voluto: la capriola non si interrompe)


# --------------------------------------------------
# Funzioni di supporto
# --------------------------------------------------
func _jump() -> void:
	velocity.y = JUMP_VELOCITY
	_change_state(State.JUMP)


func _start_roll(direction: float) -> void:
	roll_direction = sign(direction)
	roll_timer = ROLL_DURATION
	_change_state(State.ROLL)


func _change_state(new_state: State) -> void:
	# Evitiamo di riavviare la stessa animazione
	if state == new_state:
		return

	# Se usciamo da ROLL, riattiviamo le collisioni normali
	if state == State.ROLL:
		set_collision_layer_value(1, true)

	state = new_state

	match state:
		State.IDLE:
			anim.play("idle")
		State.RUN:
			anim.play("run")
		State.JUMP:
			anim.play("jump")
		State.ROLL:
			# Durante la capriola il player è invulnerabile:
			# lo togliamo dal layer 1 così le killzone non lo rilevano
			set_collision_layer_value(1, false)
			anim.play("roll")
