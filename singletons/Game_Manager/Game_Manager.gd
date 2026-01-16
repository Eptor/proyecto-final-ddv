extends Node

# Inventario: diccionario con { "nombre_item": cantidad }
var inventory: Dictionary = {}
var money: int = 0
var store_items: Array = [
	{"name": "Salud Pequeña", "price": 50, "quantity": 10, "heal": 20},
	{"name": "Salud Grande", "price": 100, "quantity": 5, "heal": 50},
	{"name": "Poción de Daño", "price": 150, "quantity": 4, "damage": 75},
]


func _ready() -> void:
	money = 500


func add_item(item_name: String, quantity: int = 1) -> void:
	if item_name in inventory:
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity
	print("✓ Se añadió: %s x%d" % [item_name, quantity])


func remove_item(item_name: String, quantity: int = 1) -> bool:
	if item_name in inventory and inventory[item_name] >= quantity:
		inventory[item_name] -= quantity
		if inventory[item_name] == 0:
			inventory.erase(item_name)
		print("✗ Se removió: %s x%d" % [item_name, quantity])
		return true
	print("✗ No hay suficientes %s" % item_name)
	return false


func get_item_quantity(item_name: String) -> int:
	return inventory.get(item_name, 0)


func add_money(amount: int) -> void:
	money += amount
	print("💰 Dinero +%d (Total: %d)" % [amount, money])


func remove_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		print("💸 Dinero -%d (Total: %d)" % [amount, money])
		return true
	print("✗ Dinero insuficiente")
	return false


func print_inventory() -> void:
	print("📦 INVENTARIO ACTUAL")
	if inventory.is_empty():
		print("Inventario vacío")
	else:
		for item_name in inventory.keys():
			print("  • %s x%d" % [item_name, inventory[item_name]])
	print("💰 Dinero: %d" % money)


func get_inventory_list() -> Dictionary:
	return inventory.duplicate()
