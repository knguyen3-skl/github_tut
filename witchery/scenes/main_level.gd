extends Node2D

@export var money: Label
@export var potato_respawn: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money.text = str(Global.money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
