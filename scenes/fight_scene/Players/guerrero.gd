extends CharacterBody2D
class_name Guerrero 

signal take_damage(amount: float)

@export var maxHealth : int = 100
@export var currentHealth : int = 100

func hurtByEnemy(amount_damage : float):
	currentHealth -= amount_damage
	currentHealth = clamp(currentHealth, 0, maxHealth)

	take_damage.emit(amount_damage)
