extends CanvasLayer

@onready var hbox_container = $HBoxContainer/NinePatchRect2/HBoxContainer
@onready var vbox_container = $HBoxContainer/NinePatchRect2/VBoxContainer

@onready var health_container = $curar_panel

#son labels de los personajes Hp HP : Numero
@onready var HpJugador1 = $HBoxContainer/NinePatchRect2/VBoxContainer/NinePatchRect/icono_personaje1/personaje1
@onready var HpJugador2 = $HBoxContainer/NinePatchRect2/VBoxContainer/NinePatchRect/icono_personaje2/personaje2
@onready var HpJugador3 = $HBoxContainer/NinePatchRect2/VBoxContainer/NinePatchRect/icono_personaje3/personaje3
@onready var HpJugador4 = $HBoxContainer/NinePatchRect2/VBoxContainer/NinePatchRect/icono_personaje4/personaje4

var potion_value : int = 0
var hp_jugador1 : int = 0  # HP actual de cada personaje
var hp_jugador2 : int = 0
var hp_jugador3 : int = 0
var hp_jugador4 : int = 0

var hp_max : int = 100  # HP máximo

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  
	actualizar_labels()  # Inicializa los labels

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = visible  
		
func _on_items_pressed() -> void:
	regresar_menu_pausa()

func _on_return_pressed() -> void:
		visible = !visible
		get_tree().paused = visible  

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_potion_red_pressed() -> void:
	potion_value = 25 
	health_container.visible = true

func _on_potion_yellow_pressed() -> void:
	potion_value = 50 
	health_container.visible = true

func _on_potion_purple_pressed() -> void:
	potion_value = 100 
	health_container.visible = true

func _on_personaje_1_pressed() -> void:
	curar_personaje(1)
	health_container.visible = false
	regresar_menu_pausa()

func _on_personaje_2_pressed() -> void:
	curar_personaje(2)
	health_container.visible = false
	regresar_menu_pausa()
func _on_personaje_3_pressed() -> void:
	curar_personaje(3)
	health_container.visible = false
	regresar_menu_pausa()
func _on_personaje_4_pressed() -> void:
	curar_personaje(4)
	health_container.visible = false
	regresar_menu_pausa()

func curar_personaje(numero: int) -> void:
	match numero:
		1:
			hp_jugador1 = min(hp_jugador1 + potion_value, hp_max)  # No pasa del máximo
		2:
			hp_jugador2 = min(hp_jugador2 + potion_value, hp_max)
		3:
			hp_jugador3 = min(hp_jugador3 + potion_value, hp_max)
		4:
			hp_jugador4 = min(hp_jugador4 + potion_value, hp_max)
	
	actualizar_labels()
	potion_value = 0  # Reset del valor

func actualizar_labels() -> void:
	HpJugador1.text = "HP: " + str(hp_jugador1) 
	HpJugador2.text = "HP: " + str(hp_jugador2) 
	HpJugador3.text = "HP: " + str(hp_jugador3) 
	HpJugador4.text = "HP: " + str(hp_jugador4) 
	
func regresar_menu_pausa()-> void:
	vbox_container.visible = !vbox_container.visible
	hbox_container.visible = !hbox_container.visible
