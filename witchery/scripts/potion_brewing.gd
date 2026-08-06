extends ColorRect

@export var inventory: ColorRect
@export var timer: Timer
@export var money: Label
@export var sprout: Label
@export var no_money: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.show()
		elif items.is_in_group("blue_options"):
			items.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.pause == true:
		hide()

func _purple_brewed() -> void:
	if Global.sprout >= 1:
		Global.sprout -= 1
		sprout.text = str(Global.sprout)
		Global.inventory["purple_potion"] += 1
		print("purple_potion")
		print(Global.inventory)
	else:
		print("brokie")
		no_money.show()
		timer.start()

func _exit_brewing() -> void:
	Global.potion_brewing = false
	hide()


func _on_timer_timeout() -> void:
	no_money.hide()


func _purple_to_blue() -> void:
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.hide()
		elif items.is_in_group("blue_options"):
			items.show()

func _blue_brewed() -> void:
	if Global.sprout >= 2:
		Global.sprout -= 2
		sprout.text = str(Global.sprout)
		Global.inventory["blue_potion"] += 1
		print("blue_potion")
		print(Global.inventory)
	else:
		print("brokie")
		no_money.show()
		timer.start()


func _blue_to_pruple() -> void:
	for items in get_children():
		if items.is_in_group("purple_options"):
			items.show()
		elif items.is_in_group("blue_options"):
			items.hide()
