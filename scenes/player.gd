extends CharacterBody2D

const TILE_SIZE = 16
#@onready var camera: Camera2D = $Camera2D
@export var camera: Camera2D
var zoom = Vector2(3,3)

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
	if not test_move(transform, dir * TILE_SIZE):
		position += dir * TILE_SIZE

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("pelotas"):
		zoom_out_camera()
		area.queue_free()

func zoom_out_camera() -> void:
	zoom -= Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.tween_property(camera, "zoom", zoom, 1.0).set_trans(Tween.TRANS_SINE)
