extends Node2D


@onready var play = $Musica_fondo

func _ready() -> void:
	play.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
