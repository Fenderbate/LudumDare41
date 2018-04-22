extends Area2D

var sound_player = preload("res://_src/Entities/Cars/Sound.tscn")

var speed = 500
var MAX_SPEED = 1000

var selected = Color(1,0.94,0,1)
var normal = Color(1,1,1,1)

enum lanes {LEFT, MIDDLE, RIGHT}
var current_lane = MIDDLE
export (String, "Left", "Middle", "Right")var lane_setter 

var left_occupied = false
var right_occupied = false

signal honk

func _ready():
	match lane_setter:
		"Left":
			current_lane = LEFT
		"Middle":
			current_lane = MIDDLE
		"Right":
			current_lane = RIGHT

func play_sound(parameter):
	var sound = sound_player.instance()
	match parameter:
		"TURN":
			sound.stream = load("res://_src/Music and Sound/Sound/Cars/turn_1.wav") if rand_range(0,100) <= 50 else load("res://_src/Music and Sound/Sound/Cars/turn_2.wav")
		"HONK":
			sound.stream = load("res://_src/Music and Sound/Sound/Cars/honk.wav")
		"CARDS":
			sound.stream = load("res://_src/Music and Sound/Sound/Obstacles/cards_hit.wav")
		"CAR":
			sound.stream = load("res://_src/Music and Sound/Sound/Obstacles/car_hit.wav")
		"STAG":
			sound.stream = load("res://_src/Music and Sound/Sound/Obstacles/deer_hit.wav")
		"POTHOLE":
			sound.stream = load("res://_src/Music and Sound/Sound/Obstacles/pothole_hit.wav")
	add_child(sound)

func affect(effect_type, amount):
	match effect_type:
		"SPEED":
			speed += amount
			return true
		"LEFT":
			if current_lane == LEFT:
				return false
			elif current_lane == MIDDLE:
				if !left_occupied:
					$Tween.interpolate_property(
							self,
							"position",
							position,
							Vector2(get_parent().get_node("Left").position.x,position.y),
							2,
							Tween.TRANS_QUART,
							Tween.EASE_OUT)
					$Tween.start()
					current_lane = LEFT
					play_sound("TURN")
					return true
				else:
					return false
			elif current_lane == RIGHT:
				if !left_occupied:
					$Tween.interpolate_property(
							self,
							"position",
							position,
							Vector2(get_parent().get_node("Middle").position.x,position.y),
							2,
							Tween.TRANS_CUBIC,
							Tween.EASE_OUT)
					$Tween.start()
					current_lane = MIDDLE
					play_sound("TURN")
					return true
				else:
					return false
		"MIDDLE":
			if current_lane == LEFT:
				if !right_occupied:
					$Tween.interpolate_property(
							self,
							"position",
							position,
							Vector2(get_parent().get_node("Middle").position.x,position.y),
							2,
							Tween.TRANS_CUBIC,
							Tween.EASE_OUT)
					$Tween.start()
					current_lane = MIDDLE
					play_sound("TURN")
					return true
				else:
					return false
			elif current_lane == MIDDLE:
				return false
			elif current_lane == RIGHT:
				if !right_occupied:
					$Tween.interpolate_property(
							self,
							"position",
							position,
							Vector2(get_parent().get_node("Middle").position.x,position.y),
							2,
							Tween.TRANS_QUART,
							Tween.EASE_OUT)
					$Tween.start()
					current_lane = MIDDLE
					play_sound("TURN")
					return true
				else:
					return false
		"RIGHT":
			if current_lane == LEFT:
				if !left_occupied:
					$Tween.interpolate_property(
							self,
							"position",
							position,
							Vector2(get_parent().get_node("Middle").position.x,position.y),
							2,
							Tween.TRANS_CUBIC,
							Tween.EASE_OUT)
					$Tween.start()
					current_lane = MIDDLE
					play_sound("TURN")
					return true
				else:
					return false
			elif current_lane == MIDDLE:
				if !left_occupied:
					$Tween.interpolate_property(
							self,
							"position",
							position,
							Vector2(get_parent().get_node("Right").position.x,position.y),
							2,
							Tween.TRANS_QUART,
							Tween.EASE_OUT)
					$Tween.start()
					current_lane = RIGHT
					play_sound("TURN")
					return true
				else:
					return false
			elif current_lane == RIGHT:
				return false
		"HONK":
			emit_signal("honk")
			play_sound("HONK")
			return true

func select(is_selected):
	if is_selected:
		$Highlight.show()
		#$Sprite.modulate = selected
	else:
		$Highlight.hide()
		#$Sprite.modulate = normal
		

func _physics_process(delta):
	if speed > 500:
		speed = 500
	elif speed < 0:
		speed = 0
