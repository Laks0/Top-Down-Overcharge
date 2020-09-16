extends KinematicBody2D

export var maxSpeed     : int   = 700
export var acceleration : int   = 1300
export var stopForce    : float = .35
export var friction     : float = .15

var velocity      : Vector2
var addedVelocity : Vector2 # Velocidad agregada que no se clampea, para usar solo en casos puntuales y no como movimiento

export var maxHealth : float = 100
export var maxEnergy : float = 100
export var charge    : float = 15 # Carga por segundo

# Weapon puede ser cualquier tipo de arma, todas las propiedades vienen de weapon 
export var weapon_class : PackedScene

var health : float
var energy : float
func _ready():
	health = maxHealth
	energy = maxEnergy

func _process(delta):
	### ENERGÍA ###
	energy += charge * delta
	energy = clamp(energy, 0, maxEnergy)
	$HUD/Energy.value = energy

	### DISPARAR ###
	if Input.is_action_just_pressed("shoot") and $BulletCooldown.is_stopped():
		shoot(weapon_class)

func _physics_process(delta):
	### MOVIMIENTO ###
	# Definir direcciones
	var dirx = int( Input.is_action_pressed("control_right") ) - int( Input.is_action_pressed("control_left") )
	var diry = int( Input.is_action_pressed("control_down") ) - int( Input.is_action_pressed("control_up") )

	velocity.x += dirx * acceleration * delta
	velocity.y += diry * acceleration * delta

	# Detenerse y girar
	if dirx != sign(velocity.x):
		velocity.x = lerp(velocity.x, 0, stopForce)
	if diry != sign(velocity.y):
		velocity.y = lerp(velocity.y, 0, stopForce)

	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clamp(velocity.y, -maxSpeed, maxSpeed)

	velocity = move_and_slide(velocity)

	addedVelocity.x = lerp(addedVelocity.x, 0, friction)
	addedVelocity.y = lerp(addedVelocity.y, 0, friction)

	move_and_slide(addedVelocity)

func shoot(weapon):
	var bullet = weapon.instance()
	var direction = get_local_mouse_position().normalized()

	if energy >= bullet.energyCost:
		get_parent().add_child(bullet)
		bullet.position = position
		bullet.direction = direction

		knock(bullet.knockback, -direction)
		$BulletCooldown.wait_time = bullet.cooldown
		$BulletCooldown.start()
		energy -= bullet.energyCost
	
func knock(ammount, direction):
	addedVelocity += direction * ammount

func hurt(damage : float, knockback : int = 0, direction : Vector2 = Vector2.ZERO):
	health -= damage
	knock(knockback, direction)
