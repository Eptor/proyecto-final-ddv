class_name Menu extends Container

signal button_focused(button: BaseButton)
signal button_pressed(button: BaseButton)

var index: int = 0

func _ready() -> void:
	for button in get_buttons_recursive():
		button.focus_entered.connect(_on_Button_focused.bind(button))
		button.pressed.connect(_on_Button_pressed.bind(button))

func get_buttons_recursive(node: Node = self) -> Array:
	var buttons: Array = []
	for child in node.get_children():
		if child is BaseButton:
			buttons.append(child)
		elif child is Container or child is Control:
			buttons += get_buttons_recursive(child)
	return buttons

func connect_to_button(target: Object, _name: String = name) -> void:
	var callable: Callable
	callable = Callable(target, "_on_%s_button_focused" % _name)
	button_focused.connect(callable)
	callable = Callable(target, "_on_%s_button_pressed" % _name)
	button_pressed.connect(callable)

func button_focus(n: int = index) -> void:
	var buttons := get_buttons_recursive()
	if n >= 0 and n < buttons.size():
		var button: BaseButton = buttons[n]
		button.grab_focus()

func _on_Button_focused(button: BaseButton) -> void:
	emit_signal("button_focused", button)

func _on_Button_pressed(button: BaseButton) -> void:
	emit_signal("button_pressed", button)

func button_focus_en_nombre(nombre: String) -> void:
	for button in get_buttons_recursive():
		if button.name == nombre:
			button.grab_focus()
			return
