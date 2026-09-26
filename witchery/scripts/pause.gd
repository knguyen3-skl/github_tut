extends ColorRect

@export var puase: Button
@export var background_on: Button
@export var background_off: Button
@export var sound_on: Button
@export var sound_off: Button
@export var back: Button
@export var canvas: CanvasLayer
@export var inventory_button: Button
@export var inventory: ColorRect
@export var brewing: ColorRect
@export var shop: ColorRect
@export var market: StaticBody2D

@onready var pause_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var button_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for items in get_children():
		if items.is_in_group("pause"):
			items.show()
		elif items.is_in_group("options"):
			items.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Runs when the player clicks continue.
func _continue() -> void:
	hide()
	Global.pause = false
	get_tree().paused = false
	
	# If the player is in the main level, set the market and inventory to closed.
	if Global.potato_fight == false:
		market.shop_opened = false
		Global.inventory_status = false
	
	if Global.sound_effects == true:
		button_sfx.play()


# Runs when the player clicks options.
func _options() -> void:
	if Global.sound_effects == true:
		pause_sfx.play()
		
	for items in get_children():
		if items.is_in_group("pause"):
			items.hide()
		elif items.is_in_group("options"):
			items.show()
	
	# Checks to see the player's current settings that they have chosen for background
	# music and displays the option buttons accordingly.
	if Global.background_music == true:
		background_on.show()
		background_off.hide()
	else:
		background_on.hide()
		background_off.show()
	
	# Checks to see the player's current settings that they have chosen for sound
	# effects and displays the option buttons accordingly.
	if Global.sound_effects == true:
		sound_on.show()
		sound_off.hide()
	else:
		sound_on.hide()
		sound_off.show()


# Runs when the player clicks quit.
func _quit() -> void:
	# Takes the player back to the main menu when they want to quit the game.
	get_tree().paused = false
	if Global.sound_effects == true:
		button_sfx.play()
	
	# If the player is in the main level, set the market and inventory to closed.
	if Global.potato_fight == false:
		market.shop_opened = false
		Global.inventory_status = false
		
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")


# Runs when the player opens the pause menu in the main level.
func _open_pause() -> void:
	if Global.sound_effects == true:
		pause_sfx.play()
	
	get_tree().paused = true
	Global.pause = true
	puase.hide()
	inventory.hide()
	inventory_button.hide()
	brewing.hide()
	shop.hide()
	show()
	
	for items in canvas.get_children():
		if items.is_in_group("stats"):
			items.hide()
		elif items.is_in_group("collect"):
			items.hide()


# Runs when the player turns off the background music. 
func _background_on_to_off() -> void:
	background_on.hide()
	background_off.show()
	Global.background_music = false


# Runs when the player turns on the background music. 
func _background_off_to_on() -> void:
	background_on.show()
	background_off.hide()
	Global.background_music = true


# Runs when the player turns off the sound effects. 
func _sound_on_to_off() -> void:
	sound_on.hide()
	sound_off.show()
	Global.sound_effects = false


# Runs when the player turns on the sound effects. 
func _sound_off_to_on() -> void:
	sound_on.show()
	sound_off.hide()
	Global.sound_effects = true


# Runs when the player clicks off the option menu.
func _back_pause() -> void:
	# When the player clicks off the option menu, display the pause menu again by
	# showing the items in the pause menu and hiding the items in options.
	for items in get_children():
		if items.is_in_group("pause"):
			items.show()
		elif items.is_in_group("options"):
			items.hide()
			
	if Global.sound_effects == true:
		pause_sfx.play()
