extends Control

var main_level_scene = preload("res://scenes/main_world/main_world.tscn")

func _ready() -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_level_scene)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
