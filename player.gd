extends Area2D
signal sizeUp
signal die

@export var speed = 200
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		velocity = Vector2(0,40)
		$AnimatedSprite2D.stop()

		
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "move"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0


func _on_body_entered(body):
	#부딪혔을 때 커질건지 죽을건지 결정
	print(body.type)
	if(body.get_node("./AnimatedSprite2D").scale.x > scale.x*0.11) :
		hide()
		die.emit()
		$CollisionShape2D.set_deferred("disabled", true)
	else :
		match body.type:
			"Mob1" :
				scale += Vector2(0.02,0.02)
			"Mob2" :
				scale += Vector2(0.04,0.04)
			"Mob3" :
				scale += Vector2(0.07,0.07)
			"Mob4" :
				scale += Vector2(0.1,0.1)
		body.hide()
		body.queue_free()
		sizeUp.emit()
				
	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
