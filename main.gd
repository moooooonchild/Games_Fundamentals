extends Node

@export var mob_scene: Array[PackedScene]

var score

func _ready():
	$BGM.play()
	
func score_up():
	score += 1
	$HUD.update_score(score)
	
	if(score >= 80):
		game_clear()

func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	
func game_clear():
	$MobTimer.stop()
	$HUD.show_game_clear()
	
func new_game():
	score = 0
	$Player.scale = Vector2(0.5,0.5)
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_start_timer_timeout():
	$MobTimer.start()	

func _on_mob_timer_timeout():
	var mob
	var size = $Player.scale.x
	#크기 따라서 생성할 몹 선택
	if (size <= 1) : 
		#print("case 1")
		mob = mob_scene[randi_range(0, 1)].instantiate()
	elif (size > 1 && size <= 2 ) :
		#print("case 2")
		mob = mob_scene[randi_range(0, 2)].instantiate()
	elif (size > 2) :
		#print("case 3")
		mob = mob_scene[randi_range(1, 3)].instantiate()
	
	mob._set_size()
	
# Get the screen size
	var screen_size = get_viewport().get_visible_rect().size
	
	# Choose the velocity for the mob along the x-axis.
	var velocity = Vector2(randf_range(150.0, 300.0), 0.0)
	mob.linear_velocity = velocity
	
	# Choose a random location on the shorter side of the screen (horizontal)
	# 50% 확률로 왼쪽 또는 오른쪽 변에서 생성
	if randf() < 0.5:
		mob.position.x = 0	
	else:
		#mob.scale.x *= -1  # 오른쪽으로 이동하는 몹은 스케일을 반전
		mob.linear_velocity *= -1
		mob.position.x = screen_size.x
	
	mob.get_node('./AnimatedSprite2D').flip_h = mob.linear_velocity.x < 0	
	# 높이는 여전히 랜덤으로 설정
	mob.position.y = randf_range(0, screen_size.y)

	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
