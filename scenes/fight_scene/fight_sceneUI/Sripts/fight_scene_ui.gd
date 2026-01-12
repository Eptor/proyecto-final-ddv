extends Control

@onready var _opciones_menu: Menu = $HBoxContainer/NinePatchRect/VBoxContainer
@onready var _bot_button: TextureButton = get_node("../Bot1/Bot")


func _ready() -> void:
	_opciones_menu.button_focus(0)
	_opciones_menu.connect_to_button(self, "opcion")

func _on_opcion_button_focused(_button: BaseButton) -> void:
	pass

func _on_opcion_button_pressed(button: BaseButton) -> void:
	match button.name:
		"Attack":
			activar_seleccion_bot()
		_:
			print("Botón presionado: ", button.text)

func activar_seleccion_bot() -> void:
	if _bot_button:
		_bot_button.grab_focus()
	else:
		print("Botón 'Bot' no encontrado")
