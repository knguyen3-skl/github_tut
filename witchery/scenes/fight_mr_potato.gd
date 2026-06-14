extends Node2D
@export var health_ui: ProgressBar
@export var sp_ui: ProgressBar
@export var potato_ui: ProgressBar
@export var health: Label
@export var sp: Label
@export var potato_health: Label

@export var first_turn_p: Panel
@export var first_turn_w: Sprite2D
@export var second_turn_p: Panel
@export var second_turn_w: Sprite2D
@export var third_turn_p: Panel
@export var third_turn_w: Sprite2D

@export var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_ui.max_value = Global.player_health
	health_ui.value = Global.player_health
	health.text = str(Global.player_health)
	
	sp_ui.max_value = Global.player_special
	sp_ui.value = Global.player_special
	sp.text = str(Global.player_special)
	
	potato_ui.max_value = Global.potato_health
	potato_ui.value = Global.potato_health
	potato_health.text = str(Global.potato_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player_health <=0:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/died.tscn")


func _defend() -> void:
	if Global.turns_left >= 1:
		Global.turns_left -= 1
		_turn()
		Global.player_health += 1
		health_ui.value = Global.player_health
		health.text = str(Global.player_health)

func _attack() -> void:
	if Global.turns_left >= 1 and Global.player_special > 0:
		Global.turns_left -= 1
		_turn()
		Global.potato_health -= 1
		Global.player_special -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special

func _potion() -> void:
	if Global.turns_left >= 1:
		Global.turns_left -= 1
		print(Global.turns_left)
		_turn()
		Global.player_special += 1
		sp_ui.value = Global.player_special
		sp.text = str(Global.player_special)
		
func _turn() -> void:
	if Global.turns_left == 2:
		first_turn_p.visible = false 
		first_turn_w.visible = false 
		
	elif Global.turns_left == 1:
		second_turn_p.visible = false 
		second_turn_w.visible = false 
	
	elif Global.turns_left == 0:
		third_turn_p.visible = false 
		third_turn_w.visible = false 
		timer.start()
		
func _potato_attack() -> void:
	if Global.turns_left == 0:
		Global.player_health -= 1
		health_ui.value = Global.player_health
		health.text = str(Global.player_health)

func _potato_heal() -> void:
	Global.potato_health += 1
	potato_ui.value = Global.potato_health
	potato_health.text = str(Global.potato_health)

func _potato_turn() -> void:
	_potato_attack()
	_potato_heal()
	timer.stop()
	_turn_reset()
	
func _turn_reset() -> void:
	Global.turns_left = 3
	first_turn_p.visible = true 
	first_turn_w.visible = true 
	second_turn_p.visible = true 
	second_turn_w.visible = true 
	third_turn_p.visible = true 
	third_turn_w.visible = true 
	
