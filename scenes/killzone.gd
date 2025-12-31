extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(body) -> void:
	if body.has_method("_take_damage"):
		body._take_damage()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
