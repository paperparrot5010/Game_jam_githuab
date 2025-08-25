extends Area2D


signal collected(cookie_node)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("PLAYER"):
		emit_signal("collected",self)
		queue_free()
		
		
