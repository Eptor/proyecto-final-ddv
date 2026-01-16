extends Control
@export var enemi:Resource
@export var Espada:PartyData
@export var Bruja: PartyData
@export var Cazadora: PartyData
@export var Bardo: PartyData


@onready var _opciones_menu: Menu = $HBoxContainer/NinePatchRect/VBoxContainer
var main_level_scene = preload("res://scenes/main_world/main_world.tscn")

var Life_Player =0
var Life_Bot =0
var vida_bot: int
var vida_party: Dictionary = {}
var turn_index: int = 0
var party_order: Array = []

signal Noti_close

var barras: Dictionary = {}
func _ready() -> void:
	set_HP($"../../Bot1/bot/hp_bot",enemi.HP,enemi.HP)
	set_HP($"../../Guerrero/hp_player",Espada.HP, Espada.HP)
	set_HP($"../../Cazadora/hp_player",Espada.HP, Espada.HP)
	set_HP($"../../Bruja/hp_player",Espada.HP, Espada.HP)
	set_HP($"../../Bardo/hp_player",Espada.HP, Espada.HP)
	$"../../Bot1/bot".texture_normal =enemi.texture
	

	barras = {
		"Espada": get_node_or_null("../../Guerrero/hp_player"),
		"Bruja": get_node_or_null("../../Bruja/hp_player"),
		"Cazadora": get_node_or_null("../../Cazadora/hp_player"),
		"Bardo": get_node_or_null("../../Bardo/hp_player")
	}
	party_order = [Espada, Bruja, Cazadora, Bardo]

	Life_Player =State.HP_Actual
	Life_Bot =enemi.HP
	
	$Notificaciones.hide()
	$HBoxContainer/NinePatchRect.hide()
	$Taco.hide()
	display_text("El %s Se interpone en tu camino" % enemi.name.to_upper())
	
	if not is_connected("Noti_close", Callable(self, "_inline_noti")):
		connect("Noti_close", Callable(func():
			$HBoxContainer/NinePatchRect.show()
			$Taco.show()
			_opciones_menu.button_focus(0)
		))
	vida_bot = enemi.HP
	vida_party = {
		"Espada": Espada.HP,
		"Bruja": Bruja.HP,
		"Cazadora": Cazadora.HP,
		"Bardo": Bardo.HP
	}
	

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


func _on_items_pressed() -> void:
	var inventory = GameManager.get_inventory_list()
	if inventory.is_empty():
		display_text("No tienes items")
	else:
		var items_text = "Inventario:\n"
		for item_name in inventory.keys():
			items_text += "• %s x%d\n" % [item_name, inventory[item_name]]
		display_text(items_text)
	
var jugador1 : PartyData
func _on_attack_pressed() -> void:
	var atacante: PartyData = party_order[turn_index]

	# Si el aventurero ya está derrotado, saltar turno
	if vida_party[atacante.name] <= 0:
		turn_index = (turn_index + 1) % party_order.size()
		_on_attack_pressed()  # llamar de nuevo con el siguiente
		return

	display_text("%s atacó a %s" % [atacante.name.to_upper(), enemi.name.to_upper()])

	vida_bot -= atacante.damage
	if vida_bot < 0:
		vida_bot = 0
	set_HP($"../../Bot1/bot/hp_bot", vida_bot, enemi.HP)

	if vida_bot == 0:
		display_text("¡%s fue derrotado!" % enemi.name.to_upper())
		return

	await get_tree().create_timer(1.0).timeout
	enemy_turn()
	if all_party_defeated():
		display_text("¡Todos los aventureros fueron derrotados!")
		return

	
func enemy_turn() -> void:
	# Filtrar solo los personajes con vida > 0
	var vivos: Array = []
	for nombre in vida_party.keys():
		if vida_party[nombre] > 0:
			vivos.append(nombre)

	# Si no queda nadie vivo, termina el combate
	if vivos.is_empty():
		display_text("¡Todos los aventureros fueron derrotados!")
		return

	# Elegir aleatoriamente entre los vivos
	var objetivo = vivos[randi() % vivos.size()]
	var defensor: PartyData = get(defensor_por_nombre(objetivo))

	display_text("%s atacó a %s" % [enemi.name.to_upper(), defensor.name.to_upper()])

	vida_party[objetivo] -= enemi.damage
	if vida_party[objetivo] < 0:
		vida_party[objetivo] = 0

	var barra: TextureProgressBar = barras.get(objetivo, null)
	if barra:
		set_HP(barra, vida_party[objetivo], defensor.HP)

	if vida_party[objetivo] == 0:
		display_text("¡%s fue derrotado!" % defensor.name.to_upper())

	# Avanzar turno al siguiente aventurero
	turn_index = (turn_index + 1) % party_order.size()

func all_party_defeated() -> bool:
	for nombre in vida_party.keys():
		if vida_party[nombre] > 0:
			return false
	return true


func defensor_por_nombre(nombre: String) -> String:
	match nombre:
		"Espada": return "Espada"
		"Bruja": return "Bruja"
		"Cazadora": return "Cazadora"
		"Bardo": return "Bardo"
		_: return ""
