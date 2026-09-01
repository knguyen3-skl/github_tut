extends StaticBody2D

var player_near: bool = false
var shop_opened: bool = false

@export var e:ColorRect
@export var shop: ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	e.hide()
	shop.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the player opens the shop, load the market dialogue before the actual shop.
	if player_near == true and Input.is_physical_key_pressed(KEY_E) and shop_opened == false:
		shop_opened = true
		Global.shop_speech = false
		# Show the items involved in the dialogue and not the shop when the player first
		# interacts with the shop.
		for items in shop.get_children():
			if items.is_in_group("shop"):
				items.hide()
			elif items.is_in_group("speech"):
				items.show()
		shop.show()
	
	# When the player finsihes the market dialogue, open the shop.	
	if Input.is_action_just_pressed("next") and player_near == true and shop_opened == true:
		Global.market = true
		Global.shop_speech = true
		# Show the items in the shop menu whilst hiding the items in the speech menu
		# after the player has finished the dialogue with the shop keeper.
		for items in shop.get_children():
			if items.is_in_group("shop"):
				items.show()
			elif items.is_in_group("speech"):
				items.hide()
		
		if shop.status_empty == true:
			shop.nothing.show()
		else:
			shop.nothing.hide()


# Runs when the player enters the market's Area 2D.
func _market_entered(area: Area2D) -> void:
	# If the player is within the market's area, show the shop.
	if area.is_in_group("player"):
		e.show()
		player_near = true


# Runs when the player exits the market's Area 2D.
func _market_exited(area: Area2D) -> void:
	# If the player is not within the market area, hide the shop.
	if area.is_in_group("player"):
		shop_opened = false
		Global.shop_speech = false
		e.hide()
		shop.hide()
		player_near = false
