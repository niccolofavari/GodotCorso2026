extends Area2D



func _on_body_entered(body: Node2D) -> void:
	print("Coin collision with " + body.name) # Replace with function body.
	queue_free()
