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
@export var intro_timer: Timer

@export var basic_spell_b: Button
@export var super_cast_b: Button
@export var look_over_there_b: Button

@export var potion_menu: PanelContainer
@export var potion_exit: Button

@export var soda_b: Button
@export var soda_value:Label
@export var just_water_b: Button
@export var just_water_value:Label

var bars: bool = false
var options: bool = false
var turns: bool = false
var wand_1:bool = false
var wand_2:bool = false
var clicked: bool = false

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
"There's no need to use any potions yet, so 
lets cast a spell instead, click on the wand",
"This area displays all the spells you could
cast.",
"Each spell will have discriptions which tells
you the requirements and specifications",
"For the 'Basic Spell' it does 1 damage to 
the enemy and cost no special points",
"Now, cast the spell",
"As you could see, the spell you just casted
did 1 damage to the enemy and took away",
"as well as reduced your turns down to 2",
"This concludes introduction",
"Now go have fun and beat up some 
enemies!"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	potion_menu.hide()
	spell_menu.hide()
	potion_exit.hide()
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
				items.z_index -= 2
		text.text = intro[0]
	
		spell.mouse_filter = 2
		potion.mouse_filter = 2
		block.position = Vector2(171.0,418.0)
		text.position = Vector2(208.0,447.0)
		sub_text.position = Vector2(456.0, 554.0)
		
	else:
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.hide()
		
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	soda_value.text = str(Global.inventory["purple_potion"])
	just_water_value.text = str(Global.inventory["blue_potion"])
	
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
		for items in canvas.get_children():
			if items.is_in_group("turns"):
				items.z_index = -2
				
		light_turns.hide()
		light_potato.show()
		light_options.hide()
		block.position = Vector2(171.0,40.0)
		text.position = Vector2(208.0,70.0)
		sub_text.position = Vector2(456.0, 175.0)
		potato_bar.z_index = 3
		potato_hp.z_index = 3
		potato_health.z_index = 3
		potato_ui.z_index = 2
	
	elif counter == 8 and clicked == false:
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
		
		if wand_1 == true:
			basic_spell_b.mouse_filter = 2
			text.text = intro[11]
			counter += 1
		
	elif counter == 14:
			basic_spell_b.mouse_filter = 1
	
	if Global.intro == false and Global.pause == false and bars == false and counter < 3 and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		light_bar.show()
		
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 1
				
	elif Global.intro == false and Global.pause == false and counter >= 3 and counter <6 and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		light_bar.hide()
	
	elif Global.intro == false and Global.pause == false and counter >= 6 and options == false and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
				
	elif Global.intro == false and Global.pause == false and counter >= 8 and counter < 10 and options == true and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		
	elif Global.intro == false and Global.pause == false and counter >= 10 and counter < 14 and wand_1 == true and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		
	elif Global.intro == false and Global.pause == false and counter >= 15 and counter < 18 and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		print(counter)
		print("15")
		
	elif counter == 18 and Input.is_action_just_pressed("next"):
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.hide()


func _attack() -> void:
	if Global.intro == false:
		spell_menu.show()
		spell_opned = true
		light_options.hide()
		clicked = true
	else:
		spell_menu.show()
		spell_opned = true
		wand_1 = true
	

func _potion() -> void:
	potion_menu.show()
	potion_exit.show()
	if Global.inventory["purple_potion"] == 0:
		soda_b.hide()
	
	if Global.inventory["blue_potion"] == 0:
		just_water_b.hide()
	
	#if turns_left >= 1 and Global.player_special < Global.player_base_special:
		#turns_left -= 1
		#_turn()
		#Global.player_special += 1
		#sp_ui.value = Global.player_special
		#sp.text = str(Global.player_special)
	#elif Global.player_special == Global.player_base_special and turns_left >= 1:
		#mistake.text = str("Special Points is already maxed!")
		#mistake_timer.start()


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
	if turns_left >= 1 and Global.player_special > 0:
		turns_left -= 1
		print(turns_left)
		_turn()
		Global.potato_health -= 2
		Global.player_special -= 1
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
	if Global.intro == false and turns_left >= 1:
		turns_left -= 1
		print(turns_left)
		_turn()
		Global.potato_health -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		spell_opned = false
		spell_menu.hide()
		light_options.hide()
		intro_timer.start()
		
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.hide()
			elif items.is_in_group("turns"):
				items.z_index = 0
		
	
	elif turns_left >= 1 and Global.intro == true:
		turns_left -= 1
		print(turns_left)
		_turn()
		Global.potato_health -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		spell_opned = false
		spell_menu.hide()


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


func _continue_intro() -> void:
	print("ola")
	wand_2 = true
	for items in canvas.get_children():
		if items.is_in_group("intro"):
			items.show()
		elif items.is_in_group("turns"):
			items.z_index = 0
			
	block.position = Vector2(171.0,418.0)
	text.position = Vector2(208.0,447.0)
	sub_text.position = Vector2(456.0, 554.0)
	counter += 1
	text.text = intro[counter]
	print(counter)


func _exit_potion() -> void:
	potion_exit.hide()
	potion_menu.hide()
