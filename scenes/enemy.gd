extends Node2D

const TILE_SIZE = 16
@onready var ray_casts = {
	Vector2.RIGHT: $RayCastR,
	Vector2.LEFT: $RayCastL,
	Vector2.UP: $RayCastU,
	Vector2.DOWN: $RayCastD
}
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var last_direction = Vector2.ZERO # Aquí guardamos de dónde venimos
var direction = Vector2.RIGHT
var time_passed = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	
	if time_passed >= 2.0:
		choose_random_direction()
		move_on_grid()
		time_passed = 0.0

func choose_random_direction() -> void:
	var possible_directions = []
	
	# El opuesto real de nuestro último movimiento
	var opposite_direction = -direction 
	
	for dir in ray_casts.keys():
		var ray = ray_casts[dir]
		ray.force_raycast_update()
		
		# CONDICIÓN ESTRICTA:
		# 1. El camino debe estar libre (not is_colliding)
		# 2. La dirección no puede ser la opuesta de la que venimos
		if not ray.is_colliding() and dir != opposite_direction:
			possible_directions.append(dir)
	
	if possible_directions.size() > 0:
		# Elegimos una dirección nueva de las permitidas
		direction = possible_directions.pick_random()
	else:
		# SOLO si estamos en un callejón sin salida, permitimos volver atrás
		if not ray_casts[opposite_direction].is_colliding():
			direction = opposite_direction
		else:
			direction = Vector2.ZERO

	# Flip del sprite
	if direction.x != 0:
		animated_sprite_2d.flip_h = (direction.x < 0)

func move_on_grid() -> void:
	if direction == Vector2.ZERO: return
	
	# Antes de movernos, nos aseguramos de que no hay colisión de último segundo
	ray_casts[direction].force_raycast_update()
	if ray_casts[direction].is_colliding():
		return

	var target_pos = position + (direction * TILE_SIZE)
	
	var tween = create_tween()
	# El tiempo del tween (0.3) debe ser menor al tiempo de espera (2.0)
	tween.tween_property(self, "position", target_pos, 0.3).set_trans(Tween.TRANS_SINE)
