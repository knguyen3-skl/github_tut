extends StaticBody2D

var player_near: bool = false

@export var brewing: ColorRect
@export var inventory: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect2.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_near == true and Input.is_physical_key_pressed(KEY_E):
		print("potion")
		Global.potion_brewing = true
		brewing.show()
		inventory.hide()
		Global.inventory_status = false
		brewing.get_child(9).hide()
		brewing.get_child(10).hide()
		brewing.get_child(11).hide()
		brewing.get_child(4).show()
		brewing.get_child(5).show()
		brewing.get_child(6).show()
		

func _on_area_2d_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		$ColorRect2.show()
		player_near = true


func _on_area_2d_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_near = false
		$ColorRect2.hide()
		brewing.hide()
