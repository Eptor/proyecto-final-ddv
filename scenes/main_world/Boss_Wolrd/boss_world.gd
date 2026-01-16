extends Node2D

var shop_scene = String("res://scenes/store/store.tscn")

func _ready() -> void:
	if GameManager.last_spawn_marker != "":
		var marker = get_node_or_null(GameManager.last_spawn_marker)
		if marker:
			$Playeroverworld.global_position = marker.global_position
		GameManager.last_spawn_marker = ""


func _on_tienda_area_entered(area: Area2D) -> void:
	GameManager.last_overworld_scene = get_tree().current_scene.scene_file_path
	GameManager.last_spawn_marker = "ShopExitSpawn"
	SceneChanger.zoom_fade(shop_scene)
