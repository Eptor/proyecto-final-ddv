class_name PartyData extends Resource


@export var adventurers: Array[String] = ["Guerrero", "Bruja", "Cazadora", "Bardo"]

# Texturas opcionales (una por aventurero)
@export var textures: Array[Texture2D] = []

# HP de cada aventurero
@export var HP: Array[int] = [30, 30, 30, 30]

# Daño de cada aventurero
@export var damage: Array[int] = [20, 20, 20, 20]
