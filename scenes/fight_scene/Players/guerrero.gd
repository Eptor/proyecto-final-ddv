extends CharacterBody2D
class_name Guerrero 

@onready var anim_attack: AnimationPlayer = $AnimationAttack
@onready var anim_hurt: AnimationPlayer = $AnimationDamage
@onready var anim_death: AnimationPlayer = $AnimationDeath

signal take_damage(amount: float)

@export var maxHealth : float = 100.0
@export var currentHealth : float = 100.0


var is_dead := false

func hurtByEnemy(amount_damage: float):
	if is_dead:
		return
	currentHealth -= amount_damage
	currentHealth = clamp(currentHealth, 0, maxHealth)

	# Animación de daño
	if currentHealth > 0:
		anim_hurt.play("damage")
	else:
		die()

	take_damage.emit(amount_damage)

func die():
	is_dead = true

	# Detener otras animaciones
	anim_attack.stop()
	anim_hurt.stop()

	anim_death.play("death")

	# Opcional: desactivar colisiones
	$CollisionShape2D.disabled = true
