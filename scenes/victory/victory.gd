extends Control


func _on_main_pressed() -> void:
	SceneChanger.wipe_top_to_bottom("res://scenes/main_menu/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
