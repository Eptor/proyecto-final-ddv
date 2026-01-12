class_name Menu
extends Control

signal button_focused(button: BaseButton)
signal button_pressed(button: BaseButton)

var index: int = 0

func _ready() -> void:
	for button in get_buttons():
		if button is BaseButton:
			button.focus_entered.connect(_on_Button_focused.bind(button))
			button.pressed.connect(_on_Button_pressed.bind(button))

func get_buttons() -> Array:
	# Filtra solo los botones que sean BaseButton
	return get_children().filter(func(child): return child is BaseButton)

func connect_to_button(target: Object, _name: String = name) -> void:
	var callable: Callable
	callable = Callable(target, "_on_%sfocused" % _name)
	button_focused.connect(callable)
	callable = Callable(target, "_on_%spressed" % _name)
	button_pressed.connect(callable)

func button_focus(n: int = index) -> void:
	var buttons := get_buttons()
	if n >= 0 and n < buttons.size():
		var button: BaseButton = buttons[n]
		button.grab_focus()

func _on_Button_focused(button: BaseButton) -> void:
	emit_signal("button_focused", button)

func _on_Button_pressed(button: BaseButton) -> void:
	emit_signal("button_pressed", button)
