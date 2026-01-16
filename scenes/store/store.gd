extends Node2D

var selected_item_index: int = 0
@onready var health_potion_small: Button = $TextureRect/store_UI/HBoxContainer/NinePatchRect2/HBoxContainer/option1
@onready var health_potion_large: Button = $TextureRect/store_UI/HBoxContainer/NinePatchRect2/HBoxContainer/option2
@onready var damage_potion: Button = $TextureRect/store_UI/HBoxContainer/NinePatchRect2/HBoxContainer/option3
@onready var buy_button: Button = $TextureRect/store_UI/HBoxContainer/NinePatchRect/VBoxContainer/Attack
@onready var exit_button: Button = $TextureRect/store_UI/HBoxContainer/NinePatchRect/VBoxContainer/Run
@onready var money_label: Label = $TextureRect/store_UI/HBoxContainer/NinePatchRect/Label
var fight_scene = preload("res://scenes/fight_scene/fight_scene.tscn")

func _ready() -> void:
	print("BIENVENIDO A LA TIENDA")

	GameManager.print_inventory()

	print_store_items()
	
	update_money_label()

	health_potion_small.pressed.connect(_selectPotion.bind(0))
	health_potion_large.pressed.connect(_selectPotion.bind(1))
	damage_potion.pressed.connect(_selectPotion.bind(2))
	buy_button.pressed.connect(_on_buy_pressed)
	exit_button.pressed.connect(_on_exit_pressed)


func _selectPotion(index):
	selected_item_index = index


func _on_buy_pressed() -> void:
	buy_item(selected_item_index, 1)


func update_money_label() -> void:
	money_label.text = "$%d" % GameManager.money


func print_store_items() -> void:
	print("\nITEMS DISPONIBLES EN LA TIENDA:")
	for i in range(GameManager.store_items.size()):
		var item = GameManager.store_items[i]
		print("  [%d] %s - Precio: %d monedas (Stock: %d)" % 
			[i, item["name"], item["price"], item["quantity"]])
	print()


func buy_item(item_index: int, quantity: int) -> bool:
	if item_index < 0 or item_index >= GameManager.store_items.size():
		print("✗ Item inválido")
		return false

	var item = GameManager.store_items[item_index]
	var total_cost = item["price"] * quantity

	if item["quantity"] < quantity:
		print("✗ Stock insuficiente de %s (disponibles: %d)" % 
			[item["name"], item["quantity"]])
		return false

	if not GameManager.remove_money(total_cost):
		return false

	GameManager.add_item(item["name"], quantity)
	
	update_money_label()
	item["quantity"] -= quantity

	print("Compra exitosa: %s x%d por %d monedas" % 
		[item["name"], quantity, total_cost])

	return true


func sell_item(item_name: String, quantity: int) -> bool:
	var item_price = 0
	for item in GameManager.store_items:
		if item["name"] == item_name:
			item_price = item["price"]
			item_price = int(item_price * 0.7)
			break

	if item_price == 0:
		print("✗ No se puede vender este item")
		return false

	if not GameManager.remove_item(item_name, quantity):
		return false

	var total_gain = item_price * quantity
	GameManager.add_money(total_gain)

	print("Venta exitosa: %s x%d por %d monedas" % 
		[item_name, quantity, total_gain])

	return true


func _on_exit_pressed() -> void:
	print("Saliendo de la tienda...")
	get_tree().change_scene_to_packed(fight_scene)


func use_potion(item_name: String) -> bool:
	var heal_amount = 0
	var damage_amount = 0
	for item in GameManager.store_items:
		if item["name"] == item_name:
			heal_amount = item.get("heal", 0)
			damage_amount = item.get("damage", 0)
			break
	
	if heal_amount == 0 and damage_amount == 0:
		print("✗ No se puede usar este item")
		return false
	
	if not GameManager.remove_item(item_name, 1):
		return false
	
	if heal_amount > 0:
		State.HP_Actual = min(State.HP_Actual + heal_amount, State.HP_Max)
		print("✓ Usaste %s y recuperaste %d de vida (Vida: %d/%d)" % 
			[item_name, heal_amount, State.HP_Actual, State.HP_Max])
	elif damage_amount > 0:
		print("✓ Usaste %s causando %d de daño al enemigo" % 
			[item_name, damage_amount])
	
	return true
