extends CharacterBody2D

const TILE_SIZE = 16

func _unhandled_input(event: InputEvent) -> void:
	var direction := Vector2.ZERO
	
	# Detectamos la dirección solo cuando se presiona la tecla (just_pressed)
	if event.is_action_pressed("ui_right"):
		direction.x = 1
	elif event.is_action_pressed("ui_left"):
		direction.x = -1
	elif event.is_action_pressed("ui_up"):
		direction.y = -1
	elif event.is_action_pressed("ui_down"):
		direction.y = 1

	# Si hubo movimiento, desplazamos al personaje
	if direction != Vector2.ZERO:
		move_on_grid(direction)

func move_on_grid(dir: Vector2) -> void:
	# Multiplicamos la dirección por el tamaño del tile
	var target_position = position + (dir * TILE_SIZE)
	
	# Usamos test_move para evitar que el personaje se teletransporte dentro de una pared
	if not test_move(transform, dir * TILE_SIZE):
		position = target_position
