extends ColorRect

var on_screen: bool = true
var go_in: String = ">"
var go_out: String = "<"
var move: Vector2 = Vector2(202,0.0)

@export var potato_defeat: Label
@export var hide_show: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	potato_defeat.text = str(Global.quest_1_value)
	hide_show.text = go_in


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	potato_defeat.text = str(Global.quest_1_value)


func _hide_quest() -> void:
	# Hides the quest menu if the player hides it.
	if on_screen == true:
		on_screen = false
		for items in get_children():
			if items.is_in_group("quest"):
				items.hide()
		hide_show.text = go_out
		position += move
	else:
		# Shows the quest menu if the player clicks on it.
		on_screen = true
		for items in get_children():
			if items.is_in_group("quest"):
				items.show()
		hide_show.text = go_in
		position -= move
