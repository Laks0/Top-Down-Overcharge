extends Node2D

export var speed     : int = 1000
export var direction : Vector2

export var cooldown  : float = .3
export var knockback : int   = 170

func _process(delta):
	position += speed * direction * delta
