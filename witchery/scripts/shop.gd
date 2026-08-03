extends ColorRect

@export var player_cam: Camera2D
@export var timer:Timer
@export var broke: Label
@export var super_cast: Panel
@export var look_over_there: Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for items in get_children():
		if items.is_in_group("shop"):
			items.hide()
		elif items.is_in_group("speech"):
			items.show()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.market == true:
		player_cam.drag_horizontal_enabled = false
		player_cam.drag_vertical_enabled = false
	elif Global.market == false and Global.inventory_status == false:
		player_cam.drag_horizontal_enabled = true
		player_cam.drag_vertical_enabled = true
	
	if Global.shop["super_cast"] == "no" and Global.shop_speech == true and Global.shop["look_over_there"] == "no":
		super_cast.show()
	
	elif Global.shop["super_cast"] == "no" and Global.shop_speech == true and Global.shop["look_over_there"] == "yes":
		super_cast.show()
	
	else:
		super_cast.hide()
		
	if Global.shop["look_over_there"] == "no" and Global.shop["super_cast"] == "no" and Global.shop_speech == true:
		look_over_there.show()
		look_over_there.position = Vector2(489.0,164.0)
		
	elif Global.shop["look_over_there"] == "no" and Global.shop["super_cast"] == "yes" and Global.shop_speech == true:
		look_over_there.show()
		look_over_there.position = Vector2(229.0,164.0)
		
	else:
		look_over_there.hide()


func _exit() -> void:
	Global.market = false
	hide()


func _buy_first() -> void:
	if Global.money >= 100:
		Global.money -= 100
		print("brought!")
		Global.shop["super_cast"] = "yes"
		
	else:
		timer.start()
		broke.show()
		print("brookie ahahha")


func _on_timer_timeout() -> void:
	broke.hide()


func _buy_distract() -> void:
	if Global.money >= 50:
		Global.money -= 50
		print("brought!")
		Global.shop["look_over_there"] = "yes"
		
	else:
		timer.start()
		broke.show()
		print("brookie ahahha")
