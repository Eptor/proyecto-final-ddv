extends TextureProgressBar

@export var player: Guerrero

#por debajo del 5 porciento se mira vacia la barra ojo ahi 

func _ready() -> void:
	max_value = player.maxHealth
	value = player.currentHealth

	player.take_damage.connect(on_take_damage)

func on_take_damage(amount: float) -> void:
	value = player.currentHealth
