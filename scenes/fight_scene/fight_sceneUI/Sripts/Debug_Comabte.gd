extends Node

const Print_Current_Focus: bool = true

func _ready() -> void:
	if Print_Current_Focus:
		get_viewport().gui_focus_changed.connect(_on_viewport_gui_focus_changed)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var x: int = event.keycode
		match x:
			KEY_R:
				get_tree().reload_current_scene()
			KEY_Q:
				get_tree().quit()
			KEY_F11:
				var full := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
				var mini := DisplayServer.WINDOW_MODE_WINDOWED if full else DisplayServer.WINDOW_MODE_FULLSCREEN
				DisplayServer.window_set_mode(mini)

func _on_viewport_gui_focus_changed(node: Control) -> void:
	if Print_Current_Focus:
		print("Currently focused node: ", node)
