extends Node2D
@export var health_ui: ProgressBar
@export var sp_ui: ProgressBar
@export var potato_ui: ProgressBar
@export var health: Label
@export var sp: Label
@export var potato_hp: Label
@export var potato_health: Label
@export var potato_bar: Sprite2D

@export var first_turn_p: Panel
@export var first_turn_w: Sprite2D
@export var second_turn_p: Panel
@export var second_turn_w: Sprite2D
@export var third_turn_p: Panel
@export var third_turn_w: Sprite2D

@export var timer: Timer
@export var mistake_timer: Timer
@export var mistake: Label

@export var spell: Button
@export var potion: Button

@export var pause: ColorRect
@export var pause_button: Button

@export var canvas: CanvasLayer
@export var dark: Polygon2D
@export var light_bar: Polygon2D
@export var light_potato: Polygon2D
@export var light_options: Polygon2D
@export var block: NinePatchRect
@export var text: Label
@export var sub_text: Label

var bars: bool = false
var options: bool = false

var turns_left: int = 3
var potato_turns: int = 1
var basic_spell: int = 1

var counter = 0
var intro = [
	"This is a quick introduction to mastering
combat!",
"In the top left is your health and special 
points",
"Whenever you get attacked, you will lose
health, so be careful and don't go below 0",
"Special points can be used to cast spells, so
remember to recharge them",
"This is your enemy's health",
"Attack the enemy to defeat it",
"Down here are the different actions you
can choose from each round.",
"Each action will cost you one turn, so
decide with caution.",

]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.potato_fight = true
	health_ui.max_value = Global.player_base_health
	health_ui.value = Global.player_health
	health.text = str(Global.player_health)
	
	sp_ui.max_value = Global.player_base_special
	sp_ui.value = Global.player_special
	sp.text = str(Global.player_special)
	
	potato_ui.max_value = Global.potato_health
	potato_ui.value = Global.potato_health
	potato_health.text = str(Global.potato_health)
	
	pause.hide()
	
	if Global.intro == false:
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.show()
				
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 0
		text.text = intro[0]
	
	spell.mouse_filter = 2
	potion.mouse_filter = 2
	block.position = Vector2(171.0,418.0)
	text.position = Vector2(208.0,447.0)
	sub_text.position = Vector2(456.0, 554.0)
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.pause == false:
		pause_button.show()
		spell.show()
		potion.show()
	
	if Global.player_health <=0:
		Global.potato_fight = false
		get_tree().call_deferred("change_scene_to_file", "res://scenes/died.tscn")
	elif Global.potato_health == 0:
		Global.potato_fight = false
		print(Global.potato_fight)
		Global.money += 10
		Global.potato_health = 10
		Global.enemy_dict[Global.enemy_id] = "dead"
		print(Global.enemy_dict)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")
		
	if counter == 4:
		bars = true
		light_bar.hide()
		light_potato.show()
		light_options.hide()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 0
				
		block.position = Vector2(171.0,40.0)
		text.position = Vector2(208.0,70.0)
		sub_text.position = Vector2(456.0, 175.0)
		potato_bar.z_index = 3
		potato_hp.z_index = 3
		potato_health.z_index = 3
		potato_ui.z_index = 2
	
	if counter == 6:
		light_potato.hide()
		light_options.show()
		potato_bar.z_index = 1
		potato_hp.z_index = 0
		potato_health.z_index = 0
		potato_ui.z_index = 0
		spell.z_index = 2
		potion.z_index = 2
		options = true
	
	if Global.intro == false and bars == false and counter < 4 and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		light_bar.show()
		
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 1
				
	elif Global.intro == false and counter >= 4 and options == false and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
				
	elif Global.intro == false and counter >= 6 and options == true and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)

func _attack() -> void:
	if turns_left >= 1 and Global.player_special > 0:
		turns_left -= 1
		_turn()
		Global.potato_health -= 1
		Global.player_special -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special
		
	elif Global.player_special < basic_spell and turns_left >= 1:
		mistake.text = str("Not enough special points!")
		mistake_timer.start()

func _potion() -> void:
	if turns_left >= 1 and Global.player_special < Global.player_base_special:
		turns_left -= 1
		_turn()
		Global.player_special += 1
		sp_ui.value = Global.player_special
		sp.text = str(Global.player_special)
	
	elif Global.player_special == Global.player_base_special and turns_left >= 1:
		mistake.text = str("Special Points is already maxed!")
		mistake_timer.start()
		
func _turn() -> void:
	if turns_left == 2:
		first_turn_p.visible = false 
		first_turn_w.visible = false 
		
	elif turns_left == 1:
		second_turn_p.visible = false 
		second_turn_w.visible = false 
	
	elif turns_left == 0:
		third_turn_p.visible = false 
		third_turn_w.visible = false 
		timer.start()
		
func _potato_attack() -> void:
	if turns_left == 0:
		Global.player_health -= 1
		health_ui.value = Global.player_health
		health.text = str(Global.player_health)

func _potato_heal() -> void:
	Global.potato_health += 1
	potato_ui.value = Global.potato_health
	potato_health.text = str(Global.potato_health)

func _potato_turn() -> void:
	if potato_turns == 1:
		_potato_attack()
		timer.stop()
		_turn_reset()
		potato_turns -= 1
		
	else:
		_potato_heal()
		timer.stop()
		_turn_reset()
		potato_turns += 1
	
func _turn_reset() -> void:
	turns_left = 3
	first_turn_p.visible = true 
	first_turn_w.visible = true 
	second_turn_p.visible = true 
	second_turn_w.visible = true 
	third_turn_p.visible = true 
	third_turn_w.visible = true 

func _mistake_timeout() -> void:
	mistake_timer.stop()
	mistake.text = str("")

func _pause() -> void:
	pause.show()
	Global.pause = true
	pause_button.hide()
	spell.hide()
	potion.hide()
