extends Node

onready var start = $SteeringWheel/Start
onready var option = $SteeringWheel/Options
onready var how2play = $SteeringWheel/How2Play
onready var credits = $SteeringWheel/Credits
onready var back = $SteeringWheel/Back
onready var back2 = $SteeringWheel/Back2
onready var back3 = $SteeringWheel/Back3
onready var next = $SteeringWheel/H2P/Next
onready var prev = $SteeringWheel/H2P/Prev

var steertime = 2

var helptext_index = 0
var helptext =[
		"Drop the cards on cars - either yours or others - and progress as far as you can!",
		"The 'Faster' and 'Slower' cards are self expainatory: they make a car faster or slower.",
		"The 'Left' and 'Right' cards are also pretty simple: they make a car switch lanes.",
		"The 'Center' card makes a car go in the middle lane.",
		"The 'Horn' card does what you expect: presses the horn, that scares away animals - stags in this case.",
		"You'll meet potholes and stags. Potholes only slow you down, stags make you lose.",
		"As I said before there are cars too! If you hit them too hard, you'll lose again.",
		"Watch out for the card boxes! They can give up to 4 cards!",
		"It you want to play around, you can press space to add a random card to your deck!",
		"Also, by pressing escape you can toggle obstacle generation. (cardboxes are obstacles too)"
		]

func _ready():
	$SteeringWheel/Panel/Master.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$SteeringWheel/Panel/Music.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	# $SteeringWheel/Panel/Sound.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func steer(target):
	match target:
		start:
			get_tree().change_scene("res://_src/World/Race.tscn")
		option:
			$SteeringWheel/Tween.interpolate_property($SteeringWheel, "rect_rotation", $SteeringWheel.rect_rotation, -90, steertime, Tween.TRANS_QUART, Tween.EASE_OUT)
		how2play:
			$SteeringWheel/Tween.interpolate_property($SteeringWheel, "rect_rotation", $SteeringWheel.rect_rotation, 90, steertime, Tween.TRANS_QUART, Tween.EASE_OUT)
		credits:
			$SteeringWheel/Tween.interpolate_property($SteeringWheel, "rect_rotation", $SteeringWheel.rect_rotation, -180, steertime, Tween.TRANS_QUART, Tween.EASE_OUT)
		back, back2, back3:
			$SteeringWheel/Tween.interpolate_property($SteeringWheel, "rect_rotation", $SteeringWheel.rect_rotation, 0, steertime, Tween.TRANS_QUART, Tween.EASE_OUT)
		next:
			if helptext_index < helptext.size()-1:
				helptext_index+=1
				$SteeringWheel/H2P/Text.text = helptext[helptext_index]
				$SteeringWheel/H2P/Prev/Sprite.self_modulate = Color(1,1,1,1)
			if helptext_index == helptext.size()-1:
				$SteeringWheel/H2P/Next/Sprite.self_modulate = Color(0.5,0.5,0.5,1)
		prev:
			if helptext_index > 0:
				helptext_index-=1
				$SteeringWheel/H2P/Text.text = helptext[helptext_index]
				$SteeringWheel/H2P/Next/Sprite.self_modulate = Color(1,1,1,1)
				
			if helptext_index == 0:
				$SteeringWheel/H2P/Prev/Sprite.self_modulate = Color(0.5,0.5,0.5,1)
	$SteeringWheel/Tween.start()


func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)
	
func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),value)

func _on_Sound_value_changed(value):
	pass #AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),value)
