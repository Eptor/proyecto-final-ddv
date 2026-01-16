extends CharacterBody2D

@export var speed := 50
var direction := -1  # empieza hacia la izquierda

@onready var raycast := $RayCast2D
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
