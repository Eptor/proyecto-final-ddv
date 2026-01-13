extends Node2D

var selected_item_index: int = 0
@onready var health_potion: Button = $TextureRect/store_UI/HBoxContainer/NinePatchRect2/HBoxContainer/Health
@onready var buy_button: Button = $TextureRect/store_UI/HBoxContainer/NinePatchRect/VBoxContainer/Buy

func _ready() -> void:
	print("BIENVENIDO A LA TIENDA")
	
	game_manager.print_inventory()
	
	print_store_items()
	
	health_potion.pressed.connect(_selectPotion.bind(0))
	buy_button.pressed.connect(buy_item.bind(selected_item_index, 1))

	
	
	
func _selectPotion(index):
	selected_item_index = index


func print_store_items() -> void:
	print("\nITEMS DISPONIBLES EN LA TIENDA:")
	for i in range(game_manager.store_items.size()):
		var item = game_manager.store_items[i]
		print("  [%d] %s - Precio: %d monedas (Stock: %d)" % 
			[i, item["name"], item["price"], item["quantity"]])
	print()


func buy_item(item_index: int, quantity: int) -> bool:
	if item_index < 0 or item_index >= game_manager.store_items.size():
		print("✗ Item inválido")
		return false
	
	var item = game_manager.store_items[item_index]
	var total_cost = item["price"] * quantity
	
	if item["quantity"] < quantity:
		print("✗ Stock insuficiente de %s (disponibles: %d)" % 
			[item["name"], item["quantity"]])
		return false
	
	if not game_manager.remove_money(total_cost):
		return false
	
	game_manager.add_item(item["name"], quantity)
	item["quantity"] -= quantity
	
	print("Compra exitosa: %s x%d por %d monedas" % 
		[item["name"], quantity, total_cost])
	
	return true


func sell_item(item_name: String, quantity: int) -> bool:
	var item_price = 0
	for item in game_manager.store_items:
		if item["name"] == item_name:
			item_price = item["price"]
			item_price = int(item_price * 0.7)
			break
	
	if item_price == 0:
		print("✗ No se puede vender este item")
		return false
	
	if not game_manager.remove_item(item_name, quantity):
		return false
	
	var total_gain = item_price * quantity
	game_manager.add_money(total_gain)
	
	print("Venta exitosa: %s x%d por %d monedas" % 
		[item_name, quantity, total_gain])
	
	return true
