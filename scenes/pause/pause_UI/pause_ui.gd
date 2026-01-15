extends CanvasLayer

@onready var hbox_container = $HBoxContainer/NinePatchRect2/HBoxContainer
@onready var vbox_container = $HBoxContainer/NinePatchRect2/VBoxContainer

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = visible  


func _on_items_pressed() -> void:
	vbox_container.visible = !vbox_container.visible
	hbox_container.visible = !hbox_container.visible

func _on_return_pressed() -> void:
		visible = !visible
		get_tree().paused = visible  


func _on_exit_pressed() -> void:
	get_tree().quit()
