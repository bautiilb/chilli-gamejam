extends Control

# Arrastra aquí la ruta de tu primera escena de nivel
@export var first_level_path: String = "res://niveles/nivel_1.tscn"

var bus_index: int

func _ready():
	# Configuración inicial del Slider (de la respuesta anterior)
	bus_index = AudioServer.get_bus_index("Music")
	$CenterContainer/VBoxContainer/HSlider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))



func _on_button_pressed() -> void:
		# Cambia la escena a la del primer nivel
	get_tree().change_scene_to_file("res://scenes/nivel_01.tscn" )


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
