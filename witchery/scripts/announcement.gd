extends ColorRect
@export var sprout: Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Sets the amount of sprouts the player recieves on the announcement to the randomised
	# Number stored in the Global script after battle
	sprout.text = str(Global.sprout_reward)
