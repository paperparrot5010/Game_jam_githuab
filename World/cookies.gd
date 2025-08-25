extends Area2D

@export var speed = 150
@onready var Player = get_tree().get_first_node_in_group("Player")


func _physics_process(delta: float) -> void:
	var direction = position.direction_to(Player.global_position).normalized()
	var velocity = direction * speed 
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("PLAYER"):
		
		print (1)
		
