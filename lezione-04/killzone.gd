extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	# Se il player sta rollando, è invulnerabile
	if body.has_method("is_rolling") and body.is_rolling():
		return
	timer.ignore_time_scale = true
	body.get_node("CollisionShape2D").queue_free()
	print("Timer started!")
	timer.start()
	Engine.time_scale = 0.1
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
