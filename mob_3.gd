extends RigidBody2D

var type = "Mob3"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()

func _set_size():
	var num = randf_range(1.5, 2.5)
	$AnimatedSprite2D.scale *= Vector2(num, num) 
	$CollisionPolygon2D.scale *= Vector2(num, num)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
