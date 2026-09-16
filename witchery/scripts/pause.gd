extends ColorRect
@onready var pause_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var button_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D2

@export var puase: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Runs when the player clicks continue.
func _continue() -> void:
	hide()
	button_sfx.play()
	Global.pause = false


# Runs when the player clicks options.
func _options() -> void:
	button_sfx.play()
	pass # Replace with function body.


# Runs when the player clicks quit.
func _quit() -> void:
	# Takes the player back to the main menu when they want to quit the game.
	button_sfx.play()
	Global.pause = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")


# Runs when the player clicks off the pause menu.
func _close() -> void:
	Global.pause = false
	pause_sfx.play()
	hide()


# Runs when the player opens the pause menu.
func _open_pause() -> void:
	Global.pause = true
	pause_sfx.play()
	show()
