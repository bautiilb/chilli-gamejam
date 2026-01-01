extends CharacterBody2D

const TILE_SIZE = 16
@export var camera: Camera2D
var zoom = Vector2(3,3)
var lastPosition : Vector2
var canTakeDamage : bool = true

var vivo : bool = true
var health = 3
# CORRECCIÓN 1: Declarar el array vacío correctamente
var heartList : Array = [] 

func _ready() -> void:
	lastPosition = position
	
	# 2. Acceso directo al contenedor (si usas el %UniqueName)
	var heartParent = %HBoxContainer 
	
	# 3. Limpiamos y llenamos el array de una forma más directa
	heartList.clear()
	for rect in heartParent.get_children():
		if rect.get_child_count() > 0:
			heartList.append(rect.get_child(0))
	
	_update_heart_display()

func _take_damage():
	if not canTakeDamage or health <= 0:
		return

	# Bloqueamos el daño inmediatamente
	canTakeDamage = false
	
	health -= 1
	_update_heart_display()
	
	# Lo movemos a la posición anterior
	position = lastPosition
	
	# Pequeño parpadeo rojo para feedback visual
	var tween = create_tween()
	modulate = Color.RED
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	# Esperamos un poquito antes de dejar que reciba daño otra vez
	if health >= 1:
		await get_tree().create_timer(0.2).timeout
		canTakeDamage = true
	else:
		morir()
	

func morir():
	vivo = false
	get_tree().reload_current_scene()

func _update_heart_display():
	for i in range(heartList.size()):
		var heartAnim = heartList[i]
		# Verificamos que sea un nodo válido antes de darle órdenes
		if is_instance_valid(heartAnim):
			if i < health:
				heartAnim.play("vida") # Asegúrate que se llame "vida" en el SpriteFrames
			else:
				heartAnim.play("vacio")

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
	lastPosition = position
	# Multiplicamos la dirección por el tamaño del tile
	var target_position = position + (dir * TILE_SIZE)
	
	# Usamos test_move para evitar que el personaje se teletransporte dentro de una pared
	if not test_move(transform, dir * TILE_SIZE):
		position += dir * TILE_SIZE

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("pelotas"):
		zoom_out_camera()
		area.queue_free()

func zoom_out_camera() -> void:
	if zoom == Vector2(3,3):
		zoom -= Vector2( 0.4, 0.4)
	elif zoom == Vector2(2.6,2.6):
		zoom = Vector2( 2, 2)
	var tween = create_tween()
	tween.tween_property(camera, "zoom", zoom, 1.0).set_trans(Tween.TRANS_SINE)
	
