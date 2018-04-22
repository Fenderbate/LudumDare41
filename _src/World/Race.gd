extends Node

var card_faster =  [preload("res://_src/Entities/Card/faster.png"), "Go Faster!", "Step on the gas baby!", "SPEED", round(rand_range(20,40))]
var card_slower = [preload("res://_src/Entities/Card/slower.png"), "Go Slower!", "Slow down, Big Boy!", "SPEED", round(rand_range(-40,-20))]
var card_right = [preload("res://_src/Entities/Card/right.png"),"Go Right!","Don't hit anything, please!","RIGHT"]
var card_middle = [preload("res://_src/Entities/Card/center.png"),"Go Middle!","Right between them!","MIDDLE"]
var card_left = [preload("res://_src/Entities/Card/left.png"),"Go Left!","Use the turn signal!","LEFT"]
var card_honk = [preload("res://_src/Entities/Card/honk.png"),"HONK!","GET OUT OF THE WAY, DAMN DEER!!","HONK"]

var cards = [card_faster, card_slower, card_right, card_middle, card_left, card_honk]

var car = preload("res://_src/Entities/Cars/Enemy/Enemy.tscn")
var pothole = preload("res://_src/Entities/Obstacles/Pothole/Pothole.tscn")
var stag = preload("res://_src/Entities/Obstacles/Stag/Stag.tscn")
var cards_box = preload("res://_src/Entities/Obstacles/Cards/Cards.tscn")

var obstacles = [car, pothole, stag, cards_box]

var honked = false
var spawner_active = true
var clear = false

func _ready():
#	add_random_card()
#	add_random_card()
#	add_random_card()
#	add_random_card()
	add_card(card_left)
	add_card(card_right)
	add_card(card_left)
	add_card(card_right)
	add_card(card_left)
	add_card(card_right)
	add_card(card_honk)
	pass

func _physics_process(delta):
	
	if !$Player.lost:
		$Score.text = str("Score: ",Global.score)
		#$Road/Road1.position.y += $Player.speed*delta*3
		#$Road/Road2.position.y += $Player.speed*delta*3
		#$Road/Road3.position.y += $Player.speed*delta*3
		$Road/Road1.translate(Vector2(0,$Player.speed*delta*2))
		$Road/Road2.translate(Vector2(0,$Player.speed*delta*2))
		$Road/Road3.translate(Vector2(0,$Player.speed*delta*2))
		
		for obstacle in $Obstacles.get_children():
			if !obstacle.is_in_group("Car"): obstacle.translate(Vector2(0,$Player.speed*delta*2))
			if obstacle.is_in_group("Animal") and honked:
				obstacle.translate(Vector2(10,$Player.speed*delta*2))
				if obstacle.position.x >= 632: obstacle.queue_free()
			if obstacle.position.y > 1000 or obstacle.position.y < -2300:
				obstacle.queue_free()
		
		if Input.is_action_just_pressed("ui_accept"): add_random_card()
		if Input.is_action_just_pressed("ui_cancel"): spawner_active = !spawner_active
	else:
		spawner_active = false
		$Music.stop()
		if !clear:
			clear_cards()
			clear = true

func clear_cards():
	for slot in $"Card Slots".get_children():
		if(slot.get_child_count() > 1):
			slot.get_children()[1].queue_free()

func add_card(parameters):
	var card = load("res://_src/Entities/Card/Card.tscn").instance()
	#card.get_node("Card/Name").add_font_override("font", load("res://_src/Font/pixelsix14.ttf"))
	card.image = parameters[0]
	card.effect_name = parameters[1]
	card.effect_desc = parameters[2]
	card.effect = parameters[3]
	card.amount = parameters[4] if parameters.size()>4 else 0
	for slot in $"Card Slots".get_children():
		if slot.get_child_count() <= 1:
			card.original_pos = Vector2(0,0)#card.position
			slot.add_child(card)
			return
	print("No room for more cards!")

func add_random_card():
	randomize()
	add_card(cards[rand_range(0,cards.size())])

func add_obstacle(type, target_position):
	var obstacle = type.instance()
	obstacle.position = Vector2(target_position.x,-2000)
	if obstacle.is_in_group("Car"): obstacle.connect("honk",self,"_on_Car_honked")
	$Obstacles.add_child(obstacle)
	
	var obstacle_info = load("res://_src/World/ObstacleInfo.tscn").instance()
	obstacle_info.obstacle = weakref(obstacle)
	obstacle_info.get_node("ObstacleImage").texture = obstacle.get_node("Sprite").texture
	if obstacle.is_in_group("Car"):
		obstacle_info.get_node("ObstacleImage").self_modulate = obstacle.get_node("Sprite").self_modulate
		obstacle_info.get_node("Windows").show()
		obstacle_info.get_node("Lights").show()
	obstacle_info.global_position.x = obstacle.global_position.x
	add_child(obstacle_info)

func add_random_obstacle():
	randomize()
	add_obstacle(obstacles[round(rand_range(0,obstacles.size()-1))], [$Left.position, $Middle.position, $Right.position][round(rand_range(0,2))])

func _on_Road_screen_left( name ):
	get_node(str("Road/",name)).position.y = -925

func _on_Car_honked():
	honked = true
	$HonkTimer.start()

func _on_HonkTimer_timeout():
	honked = false

func _on_SpawnTimer_timeout():
	if spawner_active: add_random_obstacle()
