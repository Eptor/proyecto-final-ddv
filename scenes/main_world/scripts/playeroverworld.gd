extends CharacterBody2D

<<<<<<< HEAD
class_name Player

@onready var sprite: Sprite2D = $Sprite2D
var MOVEMENT_SPEED: float=75.0
@onready var sprite: Sprite2D = $Sprite2D
var MOVEMENT_SPEED: float=100.0

func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()

func get_input(delta: float):
	velocity.x=0
	velocity.y=0
	if(Input.is_action_pressed("left")):
		velocity.x =-MOVEMENT_SPEED
		sprite.flip_h=false
	elif(Input.is_action_pressed("rigth")):
		velocity.x = MOVEMENT_SPEED
		sprite.flip_h=true
	if(Input.is_action_pressed("abajo")):
		velocity.y=MOVEMENT_SPEED
	elif (Input.is_action_pressed("arriba")):
		velocity.y=-MOVEMENT_SPEED
