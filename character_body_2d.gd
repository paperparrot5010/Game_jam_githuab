extends CharacterBody2D

var speed = 200
var gravity = 13
var jump = 300

var collected_cookies = []
@export var cookie_follow_distance = 50 # Distance between cookies in the chain
@export var cookie_follow_lag = 0.1 # How much the cookies lag behind the player

func _ready():
	# Connect to all existing cookies in the scene
	for cookie in get_tree().get_nodes_in_group("Cookies"):
		cookie.connect("collected", _on_cookie_collected)

func _physics_process(_delta: float) -> void:
	# ... (existing player movement and animation code)
	#Move right:
	if Input.is_action_pressed("r"):
		$AnimatedSprite2D.flip_h = false
		velocity.x = speed
	#Move left:
	elif Input.is_action_pressed("l"):
		$AnimatedSprite2D.flip_h = true
		velocity.x = -speed
	#Stop
	else:
		velocity.x = 0
	#Animations :

	if not is_on_floor():
		if velocity.y < 0 :
			$AnimatedSprite2D.play("JUMP")
		if velocity.y > 0 :
			$AnimatedSprite2D.play("JUMP")
	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.play("RUN")
		if velocity.x == 0:
			$AnimatedSprite2D.play("IDLE")
	# Apply gravity:
	if not is_on_floor():
		velocity.y += gravity

	# Jump:
	if is_on_floor() and Input.is_action_just_pressed("u") :
		velocity.y = -jump

	move_and_slide()

	# Update collected cookie positions
	for i in range(collected_cookies.size()):
		var target_position
		if i == 0:
			# First cookie follows the player directly
			target_position = global_position - (velocity.normalized() * cookie_follow_distance)
		else:
			# Subsequent cookies follow the previous cookie in the chain
			target_position = collected_cookies[i-1].global_position - (velocity.normalized() * cookie_follow_distance)

		# Smoothly interpolate the cookie\"s position towards the target
		if is_instance_valid(collected_cookies[i]):
			collected_cookies[i].global_position = collected_cookies[i].global_position.lerp(target_position, cookie_follow_lag)

func _on_cookie_collected(cookie_node: Node2D) -> void:
	# Add the collected cookie to the array
	collected_cookies.append(cookie_node)
	# Ensure the cookie remains visible and its position can be updated
	cookie_node.visible = true
	cookie_node.set_process_mode(Node.PROCESS_MODE_INHERIT)
	
	# Reparent the cookie to the player to keep it in the player\"s local space
	cookie_node.get_parent().remove_child(cookie_node)
	add_child(cookie_node)
