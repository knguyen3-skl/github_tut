extends StaticBody2D

var player_near: bool = false

@export var e: ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	e.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the player is near the NPC and clicks E, talk to the NPC.
	if player_near == true and Input.is_physical_key_pressed(KEY_E):
		Global.talking = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	# Show the interact button if the player is near the NPC.
	e.show()
	player_near = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	# Hide the interact button if the player is far away from the NPC.
	e.hide()
	player_near = false
	
