extends StaticBody2D

var player_near: bool = false

@export var brewing: ColorRect
@export var inventory: ColorRect
@export var player_health: ProgressBar
@export var player_special: ProgressBar
@export var health: Label
@export var special: Label
@export var e: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	e.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Checks if the player is near the cauldron/ inside the area2D, and the player
	# presses E displays the brewing menu and hides the inventory if opened
	if player_near == true and Input.is_physical_key_pressed(KEY_E):
		Global.potion_brewing = true
		brewing.show()
		inventory.hide()
		Global.inventory_status = false
		# Shows the first page of the brewing menu for the pruple potion and hides the
		# blue options because thr purple potion will be the first option the player sees
		for items in brewing.get_children():
			if items.is_in_group("blue_options"):
				items.hide()
			elif items.is_in_group("purple_options"):
				items.show()
		

# If the player is in the area2D, set the player to near and show the interaction
func _on_area_2d_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		e.show()
		player_near = true


# If the player exits the area2D, set the player to not near and hide the interaction
func _on_area_2d_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_near = false
		e.hide()
		brewing.hide()


func _healing(area: Area2D) -> void:
	# Heals the player to their maximum base health when the player is within its area2D
	if area.is_in_group("player"):
		Global.player_health = Global.player_base_health
		player_health.value = Global.player_health
		health.text = str(Global.player_health)
		Global.player_special = Global.player_base_special
		player_special.value = Global.player_special
		special.text = str(Global.player_special)
