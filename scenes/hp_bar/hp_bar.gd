extends TextureProgressBar

@export var player: Guerrero
var HP_Actual = 35
var HP_Max = 50
var damage = 20

#por debajo del 5 porciento se mira vacia la barra ojo ahi 

func _ready() -> void:
	pass
	#max_value = player.maxHealth
	#value = player.currentHealth

#	player.take_damage.connect(on_take_damage)

func on_take_damage(amount: float) -> void:
	value = player.currentHealth
