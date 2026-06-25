extends ColorRect

@export var inventory: ColorRect
@export var timer: Timer
@export var money: Label
@export var no_money: Label
@export var purple_button: TextureButton
@export var blue_button: TextureButton
@export var purple_price: Label
@export var blue_price: Label
@export var purple_potion: Sprite2D
@export var blue_potion: Sprite2D
@export var purple_to_blue: Button
@export var blue_to_purple: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blue_button.hide()
	blue_price.hide()
	blue_potion.hide()
	blue_to_purple.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _purple_brewed() -> void:
	if Global.money >= 20:
		Global.money -= 20
		money.text = str(Global.money)
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
	purple_button.hide()
	purple_price.hide()
	purple_potion.hide()
	purple_to_blue.hide()
	blue_button.show()
	blue_price.show()
	blue_potion.show()
	blue_to_purple.show()

func _blue_brewed() -> void:
	if Global.money >= 30:
		Global.money -= 30
		money.text = str(Global.money)
		Global.inventory["blue_potion"] += 1
		print("blue_potion")
		print(Global.inventory)
	else:
		print("brokie")
		no_money.show()
		timer.start()


func _blue_to_pruple() -> void:
	purple_button.show()
	purple_price.show()
	purple_potion.show()
	purple_to_blue.show()
	blue_button.hide()
	blue_price.hide()
	blue_potion.hide()
	blue_to_purple.hide()
