extends Control

var main_menu = String("res://scenes/main_menu/main_menu.tscn")


func _on_texture_button_pressed() -> void:
	SceneChanger.wipe_left_to_right(main_menu)
