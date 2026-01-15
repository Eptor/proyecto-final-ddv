class_name PartyData extends Resource


@export var adventurers: Array[String] = ["Guerrero", "Bruja", "Cazadora", "Bardo"]

@export var name:String

# Texturas opcionales (una por aventurero)
@export var texture: Texture2D

# Un solo HP para todos
@export var HP: int = 30

# Un solo daño para todos
@export var damage: int = 20
