extends Area2D

export (bool)var persistent = false
export (Texture)var image = load("res://_src/Entities/Card/faster.png")
export (String, MULTILINE )var effect_name = ""
export (String, MULTILINE)var effect_desc = ""
export (String, "SPEED", "LEFT", "MIDDLE", "RIGHT", "HONK", "STEER")var effect = ""
export var amount = 0

var under_mouse = false
var follow_mouse = false
var click_pos = null
var original_pos = Vector2()

var target = null

func _ready():
	var fnt = DynamicFont.new()
	fnt.font_data = load("res://_src/Font/pixelsix14.ttf")
	$Card/Name.add_font_override("font", fnt)
	if original_pos == Vector2():
		original_pos = position
	if image != null: $Card/Image.texture = image
	$Card/Name.text = effect_name
	$Card/Name.get_font("font").size = set_font_size(effect_name.length(),32)
	$Card/Description.text = effect_desc
	#$Card/Description.get_font("font").size = set_font_size(effect_desc.length(),16)
	

func _input(event):
	if event is InputEventMouseButton and under_mouse and event.button_index == 1:
		
		if event.is_pressed():
			$DropCollision.show()
			follow_mouse = true
			if click_pos == null: click_pos = get_global_mouse_position() - global_position
		else:
			if target != null:
				if !target.is_in_group("Menu"):
					if !persistent and target.affect(effect,amount): queue_free()
					else:
						$Tween.interpolate_property(
							self,
							"position",
							position,
							original_pos,
							1,
							Tween.TRANS_EXPO,
							Tween.EASE_OUT)
						$Tween.start()
				else:
					get_parent().steer(target)
					$Tween.interpolate_property(
						self,
						"position",
						position,
						original_pos,
						1,
						Tween.TRANS_EXPO,
						Tween.EASE_OUT)
				$Tween.start()
				
				print("Add card drop animation")
			else:
				$Tween.interpolate_property(
						self,
						"position",
						position,
						original_pos,
						1,
						Tween.TRANS_EXPO,
						Tween.EASE_OUT)
				$Tween.start()
			$DropCollision.hide()
			follow_mouse = false
			click_pos = null

func _process(delta):
	if follow_mouse and click_pos != null:
		global_position = get_global_mouse_position() - click_pos
	if(get_tree().paused): print(get_parent().name)

### functions ###

func set_font_size(length, basesize):
	if length <= 8:
		return basesize
	elif length <= 12:
		return basesize * 0.75
	elif length <= 16:
		return basesize * 0.65
	else:
		return basesize * 0.5
		


### signals ###

func _on_mouse_entered():
	under_mouse = true


func _on_Card_mouse_exited():
	under_mouse = false


func _on_DropCollision_area_entered(area):
	target = area
	if !area.is_in_group("Menu"): area.select(true)


func _on_DropCollision_area_exited(area):
	target = null
	if !area.is_in_group("Menu"): area.select(false)
