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
@export var spell_menu: ColorRect
@export var potion: Button

@export var pause: ColorRect
@export var pause_button: Button

@export var canvas: CanvasLayer
@export var dark: Polygon2D
@export var light_bar: Polygon2D
@export var light_potato: Polygon2D
@export var light_options: Polygon2D
@export var light_turns: Polygon2D
@export var block: NinePatchRect
@export var text: Label
@export var sub_text: Label

@export var super_cast_b: Button
@export var look_over_there_b: Button

var bars: bool = false
var options: bool = false
var turns: bool = false
var spell_opned: bool = false

var potato_distract: bool = false

var turns_left: int = 3
var potato_turns: int = 1
var basic_spell: int = 1
var super_cast: int = 2

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
"Up here are the amount of turns you have
left each round",
"You get three turns each round and will
reset after the enemy's turn",
"This is your enemy's health",
"Attack the enemy to defeat it",
"Down here are the different actions you
can choose from each round.",
"Each action will cost you one turn, so
decide with caution.",
"For now lets cast a spell, click on the wand",
"This area displays all the spells you could
cast.",
"Each spell will have discriptions which tells
you the requirements and specifications",
"For the 'Basic Spell' it does 1 damage to 
the enemy in return for 1 special point",
"Now, cast the spell"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_menu.hide()
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
	if spell_menu.visible == true and Global.shop["super_cast"] == "yes" and Global.shop["look_over_there"] == "yes":
		super_cast_b.show()
		look_over_there_b.show()
		look_over_there_b.position = Vector2(346.0,17)
		
	elif spell_menu.visible == true and Global.shop["super_cast"] == "yes" and Global.shop["look_over_there"] == "no":
		super_cast_b.show()
		look_over_there_b.hide()
	
	elif spell_menu.visible == true and Global.shop["super_cast"] == "no" and Global.shop["look_over_there"] == "yes":
		super_cast_b.hide()
		look_over_there_b.show()
		look_over_there_b.position = Vector2(185.0,17)
	
	else:
		super_cast_b.hide()
		look_over_there_b.hide()
	
	if Global.pause == false:
		pause_button.show()
		spell.show()
		potion.show()
	
	if Global.player_health <=0:
		Global.potato_fight = false
		get_tree().call_deferred("change_scene_to_file", "res://scenes/died.tscn")
	elif Global.potato_health <= 0:
		Global.potato_fight = false
		print(Global.potato_fight)
		Global.money += 10
		Global.potato_health = 10
		Global.enemy_dict[Global.enemy_id] = "dead"
		print(Global.enemy_dict)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")
		
	if counter == 4:
		light_bar.hide()
		turns = true
		light_turns.show()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 0
				
		for items in canvas.get_children():
			if items.is_in_group("turns"):
				items.z_index += 2
		
	elif counter == 6:
		bars = true
		light_turns.hide()
		light_potato.show()
		light_options.hide()
				
		for items in canvas.get_children():
			if items.is_in_group("turns"):
				items.z_index -= 2
				
		block.position = Vector2(171.0,40.0)
		text.position = Vector2(208.0,70.0)
		sub_text.position = Vector2(456.0, 175.0)
		potato_bar.z_index = 3
		potato_hp.z_index = 3
		potato_health.z_index = 3
		potato_ui.z_index = 2
	
	elif counter == 8:
		light_potato.hide()
		light_options.show()
		potato_bar.z_index = 1
		potato_hp.z_index = 0
		potato_health.z_index = 0
		potato_ui.z_index = 0
		spell.z_index = 2
		potion.z_index = 2
		options = true
		
	elif counter == 10:
		spell.mouse_filter = 1
	
	if Global.intro == false and bars == false and counter < 3 and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		light_bar.show()
		
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 1
				
	elif Global.intro == false and counter >= 3 and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		light_bar.hide()
	
	elif Global.intro == false and counter >= 6 and options == false and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
				
	elif Global.intro == false and counter >= 8 and options == true and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)

func _attack() -> void:
	spell_menu.show()
	spell_opned = true
	

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
	if potato_turns == 1 and potato_distract == false:
		_potato_attack()
		timer.stop()
		potato_turns -= 1
		
	elif potato_turns != 1 and potato_distract == false:
		_potato_heal()
		timer.stop()
		potato_turns += 1
		
	else:
		timer.stop()
	
	_turn_reset()
	
func _turn_reset() -> void:
	print("oops")
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



func _super_cast() -> void:
	print("hello")
	if turns_left >= 1 and Global.player_special > 1:
		turns_left -= 1
		print(turns_left)
		_turn()
		Global.potato_health -= 3
		Global.player_special -= 2
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special
		spell_opned = false
		spell_menu.hide()
		
	elif Global.player_special < super_cast and turns_left >= 1:
		mistake.text = str("Not enough special points!")
		mistake_timer.start()


func _basic_spell() -> void:
	if turns_left >= 1 and Global.player_special > 0:
		turns_left -= 1
		print(turns_left)
		_turn()
		Global.potato_health -= 1
		Global.player_special -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special
		spell_opned = false
		spell_menu.hide()
		
	elif Global.player_special < basic_spell and turns_left >= 1:
		mistake.text = str("Not enough special points!")
		mistake_timer.start()


func _spell_menu_exit() -> void:
	spell_opned = false
	spell_menu.hide()


func _distract() -> void:
	if turns_left >= 1:
		turns_left -= 1
		_turn()
		print(turns_left)
		potato_distract = true
		spell_opned = false
		spell_menu.hide()
