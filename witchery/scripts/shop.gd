extends ColorRect

@export var player_cam: Camera2D
@export var timer:Timer
@export var broke: Label

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
	elif Global.market == false:
		player_cam.drag_horizontal_enabled = true
		player_cam.drag_vertical_enabled = true


func _exit() -> void:
	Global.market = false
	hide()


func _buy_first() -> void:
	if Global.money > 50:
		Global.money -= 5
		print("brought!")
	else:
		timer.start()
		broke.show()
		print("brookie ahahha")


func _on_timer_timeout() -> void:
	broke.hide()
