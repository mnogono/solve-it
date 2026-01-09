extends CharacterBody2D

@export var speed : float = 100

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = -speed
	move_and_slide()
