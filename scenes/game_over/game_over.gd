extends Control
@onready var s = $Over

func _ready() -> void:
	s.play()

func _on_continue_pressed() -> void:
	SceneChanger.change_scene("res://scenes/main_menu/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
