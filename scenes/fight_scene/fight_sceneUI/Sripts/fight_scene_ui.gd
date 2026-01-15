extends Control
@export var enemi:Resource
<<<<<<< Updated upstream
=======
@export var Espada:PartyData
@export var Bruja: PartyData
@export var Cazadora: PartyData
@export var Bardo: PartyData
>>>>>>> Stashed changes

@onready var _opciones_menu: Menu = $HBoxContainer/NinePatchRect/VBoxContainer
var main_level_scene = preload("res://scenes/main_world/main_world.tscn")

var Life_Player =0
var Life_Bot =0

var Life_Player =0
var Life_Bot =0

signal Noti_close


func _ready() -> void:
	set_HP($"../../Bot1/bot/hp_bot",enemi.HP,enemi.HP)
	set_HP($"../../Guerrero/hp_player",State.HP_Actual,State.HP_Max)
	$"../../Bot1/bot".texture_normal =enemi.texture
	
	Life_Player =State.HP_Actual
	Life_Bot =enemi.HP
	
	$Notificaciones.hide()
	$HBoxContainer/NinePatchRect.hide()
	$Taco.hide()
	display_text("El %s Se interpone en tu camino" % enemi.name.to_upper())
<<<<<<< Updated upstream
	
	_opciones_menu.button_pressed.connect(_on_opcion_button_pressed)
=======
>>>>>>> Stashed changes
	
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
			_on_attack_pressed()
		"Items":
			_on_items_pressed()
		"Run":
			_on_run_pressed()
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

# El boton dchange_scene_to_packed(main_level_scene regresarte al mundo y salir del combate
func _on_run_pressed() -> void:
	display_text("Se evitó el Combate")
	await get_tree().create_timer(2.0).timeout  # espera 2 segundos
	get_tree().quit()


<<<<<<< Updated upstream
func _on_attack_pressed() -> void:
	display_text("%s Ataco al enemigo" % enemi.name.to_upper())
	activar_seleccion_bot()


func _on_items_pressed() -> void:
	var inventory = GameManager.get_inventory_list()
	if inventory.is_empty():
		display_text("No tienes items")
	else:
		var items_text = "Inventario:\n"
		for item_name in inventory.keys():
			items_text += "• %s x%d\n" % [item_name, inventory[item_name]]
		display_text(items_text)
=======
	
var jugador1 : PartyData
func _on_attack_pressed() -> void:
	jugador1 =Espada
	display_text("%s atacó a %s" % [jugador1.name.to_upper(), enemi.name.to_upper()])
	
>>>>>>> Stashed changes
