extends ColorRect

var purplepotion: String = "purple_potion"
var bluepotion: String = "blue_potion"

@export var purple_potion: Label
@export var blue_potion: Label
@export var player_cam: Camera2D
@export var brewing_potion: ColorRect
@export var player: CharacterBody2D
@export var purple:Panel
@export var blue:Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# When the game starts, hide the inventory as the player has not opened it yet.
	hide()
	purple_potion.text = str(Global.inventory[purplepotion])
	blue_potion.text = str(Global.inventory[bluepotion])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the player has the pause menu opened, then hide the inventory to minimise
	# clutter and allows the player to focus on the pause menu.
	if Global.pause == true:
		hide()
		Global.inventory_status = false
		
	purple_potion.text = str(Global.inventory[purplepotion])
	blue_potion.text = str(Global.inventory[bluepotion])


# Runs when the player opens the inventory.
func _on_inventory_pressed() -> void:
	# When the player clicks the inventory button, open the inventory and set their
	# camera movemnt to non-drag so it doesn't look like their lagging.
	# If the player has another screen like potion brewing opened, close it to let them
	# focus on their inventory.
	show()
	Global.potion_brewing = false
	brewing_potion.hide()
	Global.inventory_status = true
	player_cam.drag_horizontal_enabled = false
	player_cam.drag_vertical_enabled = false
	
	# If the player has more than one potion, show it in their inventory.
	if Global.inventory[purplepotion] >= 1:
		purple.show()
	else:
		purple.hide()
	
	if Global.inventory[bluepotion] >= 1:
		blue.show()
	else:
		blue.hide()


# Runs when the player clicks off the inventory.
func _exit_inventory() -> void:
	# When the player closes their inventory, set the camera back to drag.
	hide()
	player_cam.drag_horizontal_enabled = true
	player_cam.drag_vertical_enabled = true
