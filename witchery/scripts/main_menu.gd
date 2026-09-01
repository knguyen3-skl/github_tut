extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Runs when the player presses play.
func _play_pressed() -> void:
	# When the player clicks play, load the game.
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")


# Runs when the player presses options.
func _options_pressed() -> void:
	pass # Replace with function body.


# Runs when the player presses quit.
func _quit_pressed() -> void:
	# When the player clicks quit, quit the game.
	get_tree().quit()
