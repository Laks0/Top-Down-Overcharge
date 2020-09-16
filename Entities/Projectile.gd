extends Node2D

export var speed     : int = 1000
export var direction : Vector2

export var cooldown   : float = .3
export var knockback  : int   = 170
export var energyCost : int   = 15

onready var player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	position += speed * direction * delta

	if toReturn():
		returnToPlayer()

func toReturn() -> bool:
	return !$Notifier.is_on_screen()

func returnToPlayer():
	player.energy += energyCost * 1.3 # Vuelve con un poco de energía agregada
	$Area2D.queue_free()
	# TODO: animación de volver
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		body.queue_free()
		queue_free()
