extends ColorRect
@onready var pause_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var button_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D2

@export var puase: Button

@export var background_on: Button
@export var background_off: Button
@export var sound_on: Button
@export var sound_off: Button
@export var back: Button


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
			
	if Global.background_music == true:
		background_on.show()
		background_off.hide()
	else:
		background_on.hide()
		background_off.show()
	
	if Global.sound_effects == true:
		sound_on.show()
		sound_off.hide()
	else:
		sound_on.hide()
		sound_off.show()


# Runs when the player clicks quit.
func _quit() -> void:
	# Takes the player back to the main menu when they want to quit the game.
	if Global.sound_effects == true:
		button_sfx.play()
		
	Global.pause = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")


# Runs when the player clicks off the pause menu.
func _close() -> void:
	if Global.sound_effects == true:
		pause_sfx.play()
	
	for items in get_children():
		if items.is_in_group("pause"):
			items.show()
		elif items.is_in_group("options"):
			items.hide()
	
	Global.pause = false
	hide()


# Runs when the player opens the pause menu.
func _open_pause() -> void:
	if Global.sound_effects == true:
		pause_sfx.play()
	
	Global.pause = true	
	show()


func _background_on_to_off() -> void:
	background_on.hide()
	background_off.show()
	Global.background_music = false


func _background_off_to_on() -> void:
	background_on.show()
	background_off.hide()
	Global.background_music = true


func _sound_on_to_off() -> void:
	sound_on.hide()
	sound_off.show()
	Global.sound_effects = false


func _sound_off_to_on() -> void:
	sound_on.show()
	sound_off.hide()
	Global.sound_effects = true


func _back_pause() -> void:
	for items in get_children():
		if items.is_in_group("pause"):
			items.show()
		elif items.is_in_group("options"):
			items.hide()
