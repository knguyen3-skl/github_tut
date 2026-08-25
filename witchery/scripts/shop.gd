extends ColorRect

var supercast: String = "super_cast"
var lookoverthere: String = "look_over_there"
var brought: String = "yes"
var avaliable: String = "no"
var status_empty: bool = false
var super_cast_price: int = 100
var distract_price: int = 100

@export var player_cam: Camera2D
@export var timer:Timer
@export var broke: Label
@export var super_cast: Panel
@export var look_over_there: Panel
@export var nothing: Label
@export var market: StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Loads the market dialogue before the actual shop.
	for items in get_children():
		if items.is_in_group("shop"):
			items.hide()
		elif items.is_in_group("speech"):
			items.show()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Checks if the pause menu is opened or not and hides if it is.
	if Global.pause == true:
		hide()
		Global.market = false
		player_cam.drag_horizontal_enabled = true
		player_cam.drag_vertical_enabled = true
		
	# If the market is opened, change the player's camera so that it doesn't look
	# like their lagging when moving.
	if Global.market == true:
		player_cam.drag_horizontal_enabled = false
		player_cam.drag_vertical_enabled = false
	elif Global.market == false and Global.inventory_status == false:
		player_cam.drag_horizontal_enabled = true
		player_cam.drag_vertical_enabled = true
	
	# If the spell, super cast, is still avaliable/ not brought yet, display it in the
	# shop for the player to see and purchase.
	if Global.shop[supercast] == avaliable and Global.shop_speech == true:
		super_cast.show()
	else:
		super_cast.hide()
	
	# If the spell, look over there, is still avaliable/ not brought yet, display it in the
	# shop for the player to see and purchase.	
	if Global.shop[lookoverthere] == avaliable and Global.shop_speech == true:
		look_over_there.show()
	else:
		look_over_there.hide()
	
	if Global.shop[lookoverthere] == brought and Global.shop[supercast] == brought:
		status_empty = true
		


func _exit() -> void:
	Global.market = false
	market.shop_opened = false
	hide()


func _buy_super_cast() -> void:
	# Subtracts from the player's money when brought.
	if Global.money >= super_cast_price:
		Global.money -= super_cast_price
		Global.shop[supercast] = brought
		
	else:
		timer.start()
		broke.show()


func _on_timer_timeout() -> void:
	broke.hide()


func _buy_distract() -> void:
	# Subtracts from the player's money when brought.
	if Global.money >= distract_price:
		Global.money -= distract_price
		Global.shop[lookoverthere] = brought
		
	else:
		timer.start()
		broke.show()
