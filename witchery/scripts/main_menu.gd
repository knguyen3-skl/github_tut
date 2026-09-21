extends Control

var options: bool = false

@export var canvas: CanvasLayer
@export var exit_options: Button
@export var background_on: Button
@export var background_off: Button
@export var sound_on: Button
@export var sound_off: Button

@onready var open_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var book_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for items in canvas.get_children():
		if items.is_in_group("options"):
			items.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Checks to see if the option menu is opened, and if it is, display the current
	# settings that the players have chosen.
	if options == true:
		
		# Checks to see the player's current settings that they have chosen for 
		# background music and displays the option buttons accordingly.
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


# Runs when the player presses play.
func _play_pressed() -> void:
	# When the player clicks play, load the game.
	if Global.sound_effects == true:
		open_sfx.play()
	
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")


# Runs when the player presses options.
func _options_pressed() -> void:
	# Shows the option menu as well as plays the sound effect.
	options = true
	if Global.sound_effects == true:
		book_sfx.play()
		
	for items in canvas.get_children():
		if items.is_in_group("options"):
			items.show()


# Runs when the player presses quit.
func _quit_pressed() -> void:
	# When the player clicks quit, quit the game.
	get_tree().quit()


# Runs when the player clicks to exit the option menu.
func _exit_options() -> void:
	# Hide the items apart of the options menu so that the players are back to the main
	# menu.
	options = false
	for items in canvas.get_children():
		if items.is_in_group("options"):
			items.hide()
			
	if Global.sound_effects == true:
		book_sfx.play()


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
