extends "../Car.gd"

var lost = false

func _ready():
	connect("honk",get_parent(),"_on_Car_honked")

func _process(delta):
	Global.score += (speed/100) * delta
	speed += delta / 2

func lose():
	#get_tree().paused = true
	speed = 0
	lost = true
	collision_mask = 0
	collision_layer = 0
	$Tween.stop_all()
	get_parent().add_child(load("res://_src/Menus/Lose/Lost.tscn").instance())
	#get_tree().change_scene("res://_src/Menus/Lose/Lost.tscn")
	#get_tree().add_child(load("res://_src/Menus/Lose/Lost.tscn").instance())
	#get_tree().paused = true




func _on_Player_area_entered(area):
	if area.is_in_group("Obstacle"):
		speed += round(rand_range(-20,-10))
		Global.score -= 25
		play_sound("POTHOLE")
	elif area.is_in_group("Animal"):
		play_sound("STAG")
		speed = 0
		Global.score -= 100
		lose()
	elif area.is_in_group("Cards"):
		speed += round(rand_range(-20,-10))
		for i in round(rand_range(1,4)): get_parent().add_random_card()
		area.queue_free()
		Global.score += 25
		play_sound("CARDS")
	elif area.is_in_group("Car"):
		play_sound("CAR")
		if abs(area.speed - speed) <= 100:
			if area.position.y > position.y:
				area.speed = speed / 2
				speed = speed * 1.5
				Global.score += 10
			else:
				speed = area.speed / 2
				area.speed = area.speed * 1.5
				Global.score -= 10
		else:
			lose()


func _on_LeftSide_area_entered(area):
	if area != self: left_occupied = true


func _on_LeftSide_area_exited(area):
	if area != self: left_occupied = false


func _on_RightSide_area_entered(area):
	if area != self: right_occupied = true


func _on_RightSide_area_exited(area):
	if area != self: right_occupied = false
