extends Sprite

var obstacle

func _ready():
	global_position.y = 60

func _physics_process(delta):
	if obstacle.get_ref():
		global_position.x = obstacle.get_ref().global_position.x
		if obstacle.get_ref().global_position.y >= -10:
			queue_free()
	else:
		queue_free()
