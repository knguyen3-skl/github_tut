extends ColorRect
@export var purple_potion: Label
@export var blue_potion: Label
@export var player_cam: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	purple_potion.text = str(Global.inventory["purple_potion"])
	blue_potion.text = str(Global.inventory["blue_potion"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	purple_potion.text = str(Global.inventory["purple_potion"])
	blue_potion.text = str(Global.inventory["blue_potion"])


func _on_inventory_pressed() -> void:
	show()
	player_cam.drag_horizontal_enabled = false
	player_cam.drag_vertical_enabled = false


func _exit_inventory() -> void:
	hide()
	player_cam.drag_horizontal_enabled = true
	player_cam.drag_vertical_enabled = true
