extends CharacterBody2D  # Godot 4

@export var speed := 50
var direction := -1  # empieza hacia la izquierda
var battle_scene = String("res://scenes/fight_scene/BOSS_Figth/Boss_FIGTH.tscn")

@onready var raycast := $WallDetector
@onready var sprite := $Sprite2D

enum FACING_DIRECTION{LEFT=-1, RIGHT=1}
var facing:FACING_DIRECTION=FACING_DIRECTION.LEFT

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.x=speed*facing
	if raycast.is_colliding():
		turn_around()

func turn_around():
	if facing == FACING_DIRECTION.LEFT:
		facing= FACING_DIRECTION.RIGHT
	else:
		facing=FACING_DIRECTION.LEFT
	raycast.target_position *= -1
	sprite.flip_h = !sprite.flip_h


func _on_area_2d_area_entered(area: Area2D) -> void:
	SceneChanger.flash_transition(battle_scene)
