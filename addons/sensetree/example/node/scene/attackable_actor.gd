class_name AttackableActor
extends Actor

signal attacked(node: Node2D)


func attack() -> void:
	attacked.emit(self)
	#damage/animation
	queue_free()
