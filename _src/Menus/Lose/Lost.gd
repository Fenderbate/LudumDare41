extends Node

onready var retry = $Retry
onready var quit = $Quit

func _ready():
	$Text.text += str(round(Global.score))


func steer(target):
	match target:
		retry:
			get_tree().change_scene("res://_src/World/Race.tscn")
		quit:
			get_tree().change_scene("res://_src/Menus/Start/Start.tscn")
	
	pass
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
