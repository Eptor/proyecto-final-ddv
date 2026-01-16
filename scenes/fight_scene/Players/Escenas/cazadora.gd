class_name Cazadora  
extends CharacterBody2D

@onready var anim_attack: AnimationPlayer = $AnimationAttack
@onready var anim_hurt: AnimationPlayer = $AnimationDamage
@onready var anim_death: AnimationPlayer = $AnimationDeath
@export var maxHealth: float = 100.0
@export var currentHealth: float = 100.0

signal take_damage(amount: float)

var is_dead := false

func _ready():
	anim_attack.animation_finished.connect(_on_attack_finished)

func attack():
	anim_attack.play("attack")

func hurtByEnemy(amount_damage: float):
	if is_dead:
		return

	currentHealth -= amount_damage
	currentHealth = clamp(currentHealth, 0, maxHealth)

	GameManager.player_current_hp = currentHealth

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

func _on_attack_finished(anim_name):
	if anim_name == "attack":
		emit_signal("attack_finished")
