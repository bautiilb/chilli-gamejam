extends CharacterBody2D


const SPEED = 150.0


func _physics_process(delta: float) -> void:
	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")

	# 1. Prioridad Horizontal
	if directionx != 0:
		velocity.x = directionx * SPEED
		velocity.y = 0 # Anulamos el movimiento vertical
	
	# 2. Si no hay movimiento horizontal, revisamos el vertical
	elif directiony != 0:
		velocity.y = directiony * SPEED
		velocity.x = 0 # Anulamos el movimiento horizontal
	
	# 3. Si no se presiona nada, frenamos ambos
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
