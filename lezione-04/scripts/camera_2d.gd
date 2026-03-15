extends Camera2D


func _ready() -> void:
	# Prendi il riferimento al TileMapLayer (sali nell'albero)
	var tilemap = get_tree().get_first_node_in_group("limits")

	var used_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size

	limit_left   = 0
	limit_top    = 0
	limit_right  = used_rect.end.x * tile_size.x
	limit_bottom = used_rect.end.y * tile_size.y
