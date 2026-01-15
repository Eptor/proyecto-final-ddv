extends ParallaxBackground




func _process(delta: float) -> void:
	var velocidad = 350
	
	scroll_offset.x -= velocidad * delta
	
