extends StaticBody2D

var player_near: bool = false

@export var brewing: ColorRect
@export var inventory: ColorRect
@export var player_health: ProgressBar
@export var player_special: ProgressBar
@export var health: Label
@export var special: Label

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
		brewing.get_child(12).hide()
		brewing.get_child(8).show()
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


func _healing(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("hi")
		if Global.player_health < Global.player_base_health or Global.player_special < Global.player_base_special:
			Global.player_health = Global.player_base_health
			player_health.value = Global.player_health
			health.text = str(Global.player_health)
			Global.player_special = Global.player_base_special
			player_special.value = Global.player_special
			special.text = str(Global.player_special)
