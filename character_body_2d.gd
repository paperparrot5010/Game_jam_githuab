extends CharacterBody2D
var speed = 200
var gravity = 13
var jump = 300


func _physics_process(_delta: float) -> void:
	#Move right:
	if Input.is_action_pressed("r"):
		$AnimatedSprite2D.flip_h = false
		velocity.x = speed 
		#Move left:
	elif Input.is_action_pressed("l"):
		$AnimatedSprite2D.flip_h = true
		velocity.x = -speed 
		#Stop
	else :
		velocity.x = 0
	#Animations :
	if not is_on_floor():
		if velocity.y <0 :
			$AnimatedSprite2D.play("JUMP")
		#if velocity.y >0 :
		#	$AnimatedSprite2D.play("JUMP")
	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.play("RUN")
		if velocity.x == 0:
			$AnimatedSprite2D.play("IDLE")
		
		
	#Applying gravity:
	if not is_on_floor():
		velocity.y += gravity
	#Jump:
	if is_on_floor() and Input.is_action_just_pressed("u") :
		velocity.y = -jump 
		
	

	move_and_slide()
	
