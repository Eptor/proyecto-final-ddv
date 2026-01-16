extends Control
@export var Bos:Resource
@export var Espada:PartyData
@export var Bruja: PartyData
@export var Cazadora: PartyData
@export var Bardo: PartyData


@onready var _opciones_menu: BossMenu = $BossContainer/NinePatchRect/VBoxContainer
#Aqui cambiar para iniciar luego de chocar con el jefe
#var main_level_scene = preload("res://scenes/main_world/main_world.tscn")
@onready var hbox_container = $BossContainer/NinePatchRect2/HBoxContainer
@onready var vbox_container = $BossContainer/NinePatchRect2/VBoxContainer


@onready var HpJugador1 = $BossContainer/NinePatchRect2/VBoxContainer/jugador1Label
@onready var HpJugador2 = $BossContainer/NinePatchRect2/VBoxContainer/jugador2Label
@onready var HpJugador3 = $BossContainer/NinePatchRect2/VBoxContainer/jugador3Label
@onready var HpJugador4 = $BossContainer/NinePatchRect2/VBoxContainer/jugador4Label
@onready var health_container = $curar_panel


var potion_value : int = 0
var personaje_a_curar: String = ""
var party_nodes := {} 
var Life_Player =0
var Life_Bot =0
var vida_bot: int
var vida_party: Dictionary = {}
var turn_index: int = 0
var party_order: Array = []

signal Noti_close

var barras: Dictionary = {}
func _ready() -> void:
	set_HP($"../../Bot2/Pelusin/hp_Boss",Bos.HP,Bos.HP)
	set_HP($"../../Guerrero/hp_player",Espada.HP, Espada.HP)
	set_HP($"../../Cazadora/hp_player",Espada.HP, Espada.HP)
	set_HP($"../../Bruja/hp_player",Espada.HP, Espada.HP)
	set_HP($"../../Bardo/hp_player",Espada.HP, Espada.HP)
	$"../../Bot2/Pelusin".texture_normal =Bos.texture
	
	party_nodes = {
	"Espada": get_node_or_null("../../Guerrero"),
	"Bruja": get_node_or_null("../../Bruja"),
	"Cazadora": get_node_or_null("../../Cazadora"),
	"Bardo": get_node_or_null("../../Bardo")
	}

	barras = {
		"Espada": get_node_or_null("../../Guerrero/hp_player"),
		"Bruja": get_node_or_null("../../Bruja/hp_player"),
		"Cazadora": get_node_or_null("../../Cazadora/hp_player"),
		"Bardo": get_node_or_null("../../Bardo/hp_player")
	}
	party_order = [Espada, Bruja, Cazadora, Bardo]

	Life_Player =State.HP_Actual
	Life_Bot =Bos.HP
	
	$Notificaciones.hide()
	$BossContainer/NinePatchRect.hide()
	$Taco.hide()
	display_text("El %s Se interpone en tu camino" % Bos.name.to_upper())
	
	if not is_connected("Noti_close", Callable(self, "_inline_noti")):
		connect("Noti_close", Callable(func():
			$BossContainer/NinePatchRect.show()
			$Taco.show()
			_opciones_menu.button_focus(0)
		))
	vida_bot = Bos.HP
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
		vbox_container.visible = !vbox_container.visible
		hbox_container.visible = !hbox_container.visible
	else:
		#var items_text = "Inventario:\n"
		#for item_name in inventory.keys():
			#items_text += "• %s x%d\n" % [item_name, inventory[item_name]]
		#display_text(items_text)
		vbox_container.visible = !vbox_container.visible
	
var jugador1 : PartyData
	
	
func enemy_turn() -> void:
	# Filtrar personajes vivos
	var vivos: Array = []
	for nombre in vida_party.keys():
		if vida_party[nombre] > 0:
			vivos.append(nombre)

	if vivos.is_empty():
		display_text("¡Todos los aventureros fueron derrotados!")
		return

	# Elegir objetivo vivo
	var objetivo: String = vivos[randi() % vivos.size()]
	var defensor: PartyData = get(defensor_por_nombre(objetivo))

	display_text("%s atacó a %s" % [Bos.name.to_upper(), defensor.name.to_upper()])

	var bot = get_node_or_null("../../Bot2")
	if bot and bot.has_method("attack"):
		bot.attack()
		await get_tree().create_timer(0.6).timeout

	# Aplicar daño
	vida_party[objetivo] -= Bos.damage
	if vida_party[objetivo] < 0:
		vida_party[objetivo] = 0

	# Actualizar barra de vida
	var barra: TextureProgressBar = barras.get(objetivo, null)
	if barra:
		set_HP(barra, vida_party[objetivo], defensor.HP)

	# Nodo del personaje atacado
	var nodo = party_nodes.get(objetivo, null)

	# Animación de daño o muerte
	if nodo:
		if vida_party[objetivo] > 0:
			var anim_damage: AnimationPlayer = nodo.get_node("AnimationDamage")
			if anim_damage:
				anim_damage.play("damage")
		else:
			display_text("¡%s fue derrotado!" % defensor.name.to_upper())
			var anim_death: AnimationPlayer = nodo.get_node("AnimationDeath")
			if anim_death:
				anim_death.play("death")

	# Avanzar turno
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


func _on_attack_pressed() -> void:
	var atacante: PartyData = party_order[turn_index]

	if vida_party[atacante.name] <= 0:
		turn_index = (turn_index + 1) % party_order.size()
		_on_attack_pressed()
		return

	display_text("%s ataca a %s" % [atacante.name.to_upper(), Bos.name.to_upper()])

	# Animación de ataque del personaje
	var nodo_atacante = get_current_character(atacante.name)
	if nodo_atacante:
		var anim_attack: AnimationPlayer = nodo_atacante.get_node_or_null("AnimationAttack")
		if anim_attack:
			anim_attack.play("attack")
			await anim_attack.animation_finished

	vida_bot -= atacante.damage
	if vida_bot < 0:
		vida_bot = 0
	set_HP($"../../Bot2/Pelusin/hp_Boss", vida_bot, Bos.HP)

	if vida_bot == 0:
		display_text("¡%s fue derrotado!" % Bos.name.to_upper())
		var bot = get_node_or_null("../../Bot2")
		if bot:
			var anim_enemy_death: AnimationPlayer = bot.get_node_or_null("AnimationDeath")
			if anim_enemy_death:
				anim_enemy_death.play("death")
		return

	# Animación de daño del enemigo
	var bot = get_node_or_null("../../Bot2")
	if bot:
		var anim_enemy_damage: AnimationPlayer = bot.get_node_or_null("AnimationDamage")
		if anim_enemy_damage:
			anim_enemy_damage.play("damage")

	await get_tree().create_timer(1.0).timeout
	enemy_turn()
	if all_party_defeated():
		display_text("¡Todos los aventureros fueron derrotados!")
		return


func _on_potion_red_pressed() -> void:
	potion_value = 10 
	health_container.visible = true

func _on_potion_yellow_pressed() -> void:
	potion_value = 25
	health_container.visible = true

func _on_potion_purple_pressed() -> void:
	potion_value = 50 
	health_container.visible = true


func _on_personaje_1_pressed() -> void:
	personaje_a_curar = "Espada"
	curar_jugador()
	health_container.visible = false
	regresar_menu_pausa()

func _on_personaje_2_pressed() -> void:
	personaje_a_curar = "Bruja"
	curar_jugador()
	health_container.visible = false
	regresar_menu_pausa()

func _on_personaje_3_pressed() -> void:
	personaje_a_curar = "Cazadora"
	curar_jugador()
	health_container.visible = false
	regresar_menu_pausa()

func _on_personaje_4_pressed() -> void:
	personaje_a_curar = "Bardo"
	curar_jugador()
	health_container.visible = false
	regresar_menu_pausa()

func regresar_menu_pausa()-> void:
	vbox_container.visible = !vbox_container.visible
	hbox_container.visible = !hbox_container.visible


func curar_jugador() -> void:
	if personaje_a_curar == "":
		return

	# Obtener el PartyData del personaje
	var personaje: PartyData = get(personaje_a_curar)
	if not personaje:
		return

	# Sumar vida sin exceder el máximo
	var vida_actual = vida_party[personaje_a_curar]
	var vida_nueva = min(vida_actual + potion_value, personaje.HP)
	vida_party[personaje_a_curar] = vida_nueva

	# Actualizar la barra de vida
	var barra: TextureProgressBar = barras.get(personaje_a_curar, null)
	if barra:
		set_HP(barra, vida_nueva, personaje.HP)
		
	actualizar_labels_hp()
	# Resetear la variable
	personaje_a_curar = ""

# Función para actualizar los labels de HP
func actualizar_labels_hp() -> void:
	HpJugador1.text = "Espada HP: %d" % vida_party["Espada"]
	HpJugador2.text = "Bruja HP: %d" % vida_party["Bruja"]
	HpJugador3.text = "Cazadora HP: %d" % vida_party["Cazadora"]
	HpJugador4.text = "Bardo HP: %d" % vida_party["Bardo"]


func get_current_character(nombre: String) -> Node:
	match nombre:
		"Espada": return get_node_or_null("../../Guerrero")
		"Bruja": return get_node_or_null("../../Bruja")
		"Cazadora": return get_node_or_null("../../Cazadora")
		"Bardo": return get_node_or_null("../../Bardo")
	return null
