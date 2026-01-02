extends Area2D

# Asegúrate de que esto aparezca en el inspector del AREA2D
@export_file("*.tscn") var send_to_level: String 

func _on_body_entered(body: Node2D) -> void:
	# Imprime en consola para estar seguros de que funciona
	print("Colisión detectada con: ", body.name)
	
	# Si no usas grupos todavía, quita el 'if' del grupo para probar
	if send_to_level != "":
		print("Cambiando a: ", send_to_level)
		get_tree().change_scene_to_file(send_to_level)
	else:
		print("Error: No hay nivel asignado en el inspector del Area2D")
