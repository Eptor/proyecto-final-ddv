extends Control

@onready var _opciones_menu: Menu = $HBoxContainer/NinePatchRect/VBoxContainer

func _ready() -> void:
	# Enfoca el primer botón al iniciar
	_opciones_menu.button_focus(0)
	# Conecta las señales del menú a este script
	_opciones_menu.connect_to_button(self, "opcion")

func _on_opcion_button_focused(_button: BaseButton) -> void:
	# Aquí puedes poner lógica visual (ej: resaltar botón)
	pass

func _on_opcion_button_pressed(button: BaseButton) -> void:
	print("Botón presionado: ", button.text)
