extends KinematicBody2D

export var strength  : float = 30
export var knockback : int   = 1050

onready var player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta):
	movement(delta)

func movement(delta):
	move_and_slide(300 * (player.position - position).normalized() )

func _on_Area2D_body_entered(body):
	if !body.is_in_group("Player"):
		return

	body.hurt(strength, knockback, (body.position - position).normalized())
