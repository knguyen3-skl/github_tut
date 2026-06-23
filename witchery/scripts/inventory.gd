extends ColorRect
@export var purple_potion: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	purple_potion.text = str(Global.inventory["purple_potion"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	purple_potion.text = str(Global.inventory["purple_potion"])


func _on_inventory_pressed() -> void:
	show()



func _exit_inventory() -> void:
	hide()
