extends Control
@export var enemi: Resource

@onready var _opciones_menu: Menu = $HBoxContainer/NinePatchRect/VBoxContainer

signal Noti_close


func _ready() -> void:
	set_HP($"../../Bot1/bot/hp_bot",enemi.HP,enemi.HP)
	set_HP($"../../Guerrero/hp_player",State.HP_Actual,State.HP_Max)
	
	
	$Notificaciones.hide()
	$HBoxContainer/NinePatchRect.hide()
	$Taco.hide()
	display_text("El GODIN Se interpone en tu camino")
	
	if not is_connected("Noti_close", Callable(self, "_inline_noti")):
		connect("Noti_close", Callable(func():
			$HBoxContainer/NinePatchRect.show()
			$Taco.show()
			_opciones_menu.button_focus(0)
		))

func set_HP(progress_bar,HP_Actual,HP_Max):
	progress_bar.value =HP_Actual
	progress_bar.max_value = HP_Max
	progress_bar.get_node("Label").text = "HP: %d|%d" % [HP_Actual,HP_Max]

func _input(event):
	if Input.is_action_just_pressed("ui_up")and $Notificaciones.visible:
		$Notificaciones.hide()
		emit_signal("Noti_close")


func display_text(text):
	$Notificaciones.show()
	$Notificaciones/Label.text = text

func _on_opcion_button_focused(_button: BaseButton) -> void:
	pass

func _on_opcion_button_pressed(button: BaseButton) -> void:
	match button.name:
		"Attack":
			activar_seleccion_bot()
		_:
			print("Botón presionado: ", button.text)
#"../Bot1"
func activar_seleccion_bot() -> void:
	var contenedor_bot := get_node_or_null("../../Bot1")
	if contenedor_bot:
		var boton:TextureButton = contenedor_bot.get_node("bot")
		if boton and boton is BaseButton:
			boton.grab_focus()
			if not boton.is_connected("pressed", Callable(self, "_on_enemy_pressed")):
				boton.connect("pressed", Callable(self, "_on_enemy_pressed"))
		else:
			print("No encontré el botón 'Bot'")
	else:
		print("No encontré el nodo 'Bot1'")

func _on_enemy_pressed() -> void:
	# Aquí Afectar la barra del bot 
	_opciones_menu.button_focus(0)

# El boton debera regresarte al mundo y salir del combate
func _on_run_pressed() -> void:
	display_text("Se evitó el Combate")
	await get_tree().create_timer(2.0).timeout  # espera 2 segundos
	get_tree().quit()


func _on_attack_pressed() -> void:
	pass # Replace with function body.
