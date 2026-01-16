extends CanvasLayer

@onready var wipe := ColorRect.new()
var screen_size: Vector2

func _ready():
	screen_size = get_viewport().size

	wipe.color = Color.BLACK
	wipe.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(wipe)

func change_scene(path: String):
	# Cierre
	wipe.size = Vector2(0, screen_size.y)
	wipe.position = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property(wipe, "size:x", screen_size.x, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)

		# Apertura
		wipe.position.x = 0
		var tween_back = create_tween()
		tween_back.tween_property(wipe, "position:x", screen_size.x, 1.0)\
			.set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_IN_OUT)
	)

func wipe_left_to_right(path: String, time := 1.0):
	wipe.size = Vector2(0, screen_size.y)
	wipe.position = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(wipe, "size:x", screen_size.x, time)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)

		var tween_back = create_tween()
		tween_back.tween_property(
			wipe, "position:x", screen_size.x, time
		)
	)
	

func wipe_right_to_left(path: String, time := 1.0):
	wipe.size = Vector2(0, screen_size.y)
	wipe.position = Vector2(screen_size.x, 0)

	var tween = create_tween()
	tween.tween_property(wipe, "position:x", 0, time)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)

		var tween_back = create_tween()
		tween_back.tween_property(
			wipe, "size:x", 0, time
		)
	)

func wipe_top_to_bottom(path: String, time := 1.0):
	wipe.size = Vector2(screen_size.x, 0)
	wipe.position = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(wipe, "size:y", screen_size.y, time)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)

		var tween_back = create_tween()
		tween_back.tween_property(
			wipe, "position:y", screen_size.y, time
		)
	)

func fade(path: String, time := 1.0):
	wipe.size = screen_size
	wipe.position = Vector2.ZERO
	wipe.modulate.a = 0.0
	wipe.visible = true

	var tween = create_tween()
	tween.tween_property(wipe, "modulate:a", 1.0, time)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)

		var tween_back = create_tween()
		tween_back.tween_property(
			wipe, "modulate:a", 0.0, time
		)
	)

func zoom_fade(path: String, time := 0.6):
	wipe.size = screen_size
	wipe.position = Vector2.ZERO
	wipe.modulate.a = 0.0
	wipe.scale = Vector2.ONE
	wipe.visible = true

	var tween = create_tween()
	tween.parallel().tween_property(wipe, "scale", Vector2(1.3, 1.3), time)
	tween.parallel().tween_property(wipe, "modulate:a", 1.0, time)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)

		wipe.scale = Vector2.ONE
		var tween_back = create_tween()
		tween_back.parallel().tween_property(wipe, "scale", Vector2.ONE, time)
		tween_back.parallel().tween_property(wipe, "modulate:a", 0.0, time)
	)

func flash_transition(path: String):
	wipe.color = Color.WHITE
	wipe.size = screen_size
	wipe.modulate.a = 0.0
	wipe.visible = true

	var tween = create_tween()
	tween.tween_property(wipe, "modulate:a", 1.0, 0.1)

	tween.finished.connect(func():
		get_tree().change_scene_to_file(path)

		var tween_back = create_tween()
		tween_back.tween_property(wipe, "modulate:a", 0.0, 1.0)
	)
