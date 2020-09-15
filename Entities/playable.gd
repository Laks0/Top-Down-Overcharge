extends KinematicBody2D

export var maxSpeed     : int   = 700
export var acceleration : int   = 1000
export var friction     : float = .25

var velocity : Vector2

func _process(delta):
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

	move_and_slide(velocity)

