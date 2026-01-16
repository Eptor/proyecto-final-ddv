extends Control

var main_level_scene = String("res://scenes/main_world/main_world.tscn")
var credits_scene = String("res://scenes/credits/credits.tscn")

func _on_start_button_pressed() -> void:
	SceneChanger.fade(main_level_scene)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	SceneChanger.wipe_left_to_right(credits_scene)
