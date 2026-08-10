extends ColorRect
@export var purple_potion: Label
@export var blue_potion: Label
@export var player_cam: Camera2D
@export var brewing_potion: ColorRect
@export var player: CharacterBody2D
@export var purple:Panel
@export var blue:Panel

var purplepotion: String = "purple_potion"
var bluepotion: String = "blue_potion"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	purple_potion.text = str(Global.inventory[purplepotion])
	blue_potion.text = str(Global.inventory[bluepotion])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.pause == true:
		hide()
		
	purple_potion.text = str(Global.inventory[purplepotion])
	blue_potion.text = str(Global.inventory[bluepotion])


func _on_inventory_pressed() -> void:
	show()
	Global.potion_brewing = false
	brewing_potion.hide()
	Global.inventory_status = true
	player_cam.drag_horizontal_enabled = false
	player_cam.drag_vertical_enabled = false
	
	if Global.inventory[purplepotion] >= 1:
		purple.show()
	else:
		purple.hide()
	
	if Global.inventory[bluepotion] >= 1:
		blue.show()
	else:
		blue.hide()



func _exit_inventory() -> void:
	hide()
	player_cam.drag_horizontal_enabled = true
	player_cam.drag_vertical_enabled = true
