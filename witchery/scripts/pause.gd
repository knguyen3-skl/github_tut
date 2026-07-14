extends ColorRect

@export var puase: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _continue() -> void:
	hide()
	Global.pause = false


func _options() -> void:
	pass # Replace with function body.


func _quit() -> void:
	Global.pause = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")


func _close() -> void:
	Global.pause = false
	hide()


func _open_pause() -> void:
	Global.pause = true
	show()
