extends KinematicBody2D

export var maxSpeed     : int   = 700
export var acceleration : int   = 1000
export var friction     : float = .35

var velocity : Vector2

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

	### MOVIMIENTO ###
	# Definir direcciones
	var dirx = int( Input.is_action_pressed("control_right") ) - int( Input.is_action_pressed("control_left") )
	var diry = int( Input.is_action_pressed("control_down") ) - int( Input.is_action_pressed("control_up") )

	velocity.x += dirx * acceleration * delta
	velocity.y += diry * acceleration * delta

	# Detenerse y girar
	if dirx != sign(velocity.x):
		velocity.x = lerp(velocity.x, 0, friction)
	if diry != sign(velocity.y):
		velocity.y = lerp(velocity.y, 0, friction)

	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clamp(velocity.y, -maxSpeed, maxSpeed)

	velocity = move_and_slide(velocity)


func shoot(weapon):
	var bullet = weapon.instance()
	var direction = get_local_mouse_position().normalized()

	if energy >= bullet.energyCost:
		get_parent().add_child(bullet)
		bullet.position = position
		bullet.direction = direction

		velocity -= bullet.knockback * direction 
		$BulletCooldown.wait_time = bullet.cooldown
		$BulletCooldown.start()
		energy -= bullet.energyCost

