extends Node2D
@onready var Song =$Musica_Fondo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Song.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
