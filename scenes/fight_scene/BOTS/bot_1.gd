class_name Bot1 extends Control
@onready var _bot_menu: TextureButton = get_node("bot")

func activar_seleccion_bot() -> void:
	_bot_menu.button_focus_en_nombre("Bot")
