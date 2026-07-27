extends StaticBody2D

var player_near:bool = false

@export var e:ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	e.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_near == true and Input.is_physical_key_pressed(KEY_E):
		print("helooo")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		e.show()
		player_near = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		e.hide()
		player_near = false
