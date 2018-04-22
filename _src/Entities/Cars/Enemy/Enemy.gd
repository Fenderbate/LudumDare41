extends "../Car.gd"

onready var player = get_parent().get_parent().get_node("Player")
var crashed = false

func _ready():
	speed = player.speed - rand_range(100,160)
	$Sprite.self_modulate = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1),1)

func _physics_process(delta):
	if !crashed: translate(Vector2(0,(player.speed-speed)*delta*2))
	else: translate(Vector2(0,player.speed*delta*2))
	#position.y -= (speed - player.speed)*delta

func _on_Enemy_area_entered(area):
	if area.is_in_group("Obstacle"):
		speed += round(rand_range(-20,-10))
		play_sound("POTHOLE")
	elif area.is_in_group("Animal"):
		crashed = true
		play_sound("STAG")
	elif area.is_in_group("Cards"):
		speed += round(rand_range(-20,-10))
		area.queue_free()
		play_sound("CARDS")
	
