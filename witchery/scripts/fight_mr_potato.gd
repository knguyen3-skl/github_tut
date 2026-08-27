extends Node2D

var bars: bool = false
var options: bool = false
var turns: bool = false
var wand_1:bool = false
var clicked: bool = false

var spell_opened: bool = false
var potion_opened: bool = false
var potato_distract: bool = false

var turns_left: int = 3
var potato_turns: int = 1
var potato_dead: String = "dead"
var basic_spell: int = 1
var super_cast_v: int = 2

var purple_potion: String = "purple_potion"
var blue_potion: String = "blue_potion"
var super_cast: String = "super_cast"
var look_over_there: String = "look_over_there"
var status_brought: String = "yes"

var mistake_no_sp: String = "Not enough special points!"
var mistake_no_turn: String = "Not your turn!"
var mistake_maxed: String = "Stats already maxed!"
var mistake_reset: String = ""

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
can choose from each round",
"Each action will cost you one turn, so
decide with caution",
"There's no need to use any potions yet, so 
lets cast a spell instead, click on the wand",
"This area displays all the spells you could
cast",
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

var block_position_1 = Vector2(171.0,418.0)
var text_position_1 = Vector2(208.0,447.0)
var sub_text_position_1 = Vector2(456.0, 554.0)

var block_position_2 = Vector2(171.0,40.0)
var text_position_2 = Vector2(208.0,70.0)
var sub_text_position_2 = Vector2(456.0, 175.0)

var fireball_starting = Vector2(298.0, 324.0)
var potato_idle: bool = true

var mouse_on: int = 1
var mouse_off: int = 2

var purple_potion_effect: int = 1
var blue_potion_effect_hp: int = 2
var blue_potion_effect_sp: int = 1
var super_cast_value: int = 2
var turns_value: int = 3
var reward_value: int = 30
var reward_range: int = 3
var top_layer: int = 3
var second_layer: int = 2
var second_turn: int = 2
var potato_health_max: int = 10
var start: int = 3

var turns_intro: int = 4
var potato_intro: int = 6
var action_intro: int = 8
var spell_intro: int = 10
var cast_intro: int = 14
var after_cast_intro: int = 15
var end_intro: int = 18
var click_dialogue: int = 11

@export_group("Screen Elements")
@export var player: AnimatedSprite2D
@export var health_ui: ProgressBar
@export var sp_ui: ProgressBar
@export var potato_ui: ProgressBar
@export var health: Label
@export var sp: Label
@export var potato_hp: Label
@export var potato_health: Label
@export var potato_bar: Sprite2D

@export_group("Turn Tracker")
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
@export var spell_menu: PanelContainer
@export var spell_exit: Button
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

@export var fireball: AnimatedSprite2D
@export var spell_time: Timer
@export var fireball_animation: AnimationPlayer

@export var potato: AnimatedSprite2D
@export var potato_animation: AnimationPlayer
@export var potato_idle_timer: Timer
@export var potato_heal_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.potato_fight = true
	# Sets both the player and potato animations to idle as they are not currenntly in
	# action.
	potato.animation = "idle"
	player.animation = "idle"
	
	fireball.hide()
	potion_menu.hide()
	spell_menu.hide()
	potion_exit.hide()
	spell_exit.hide()
	pause.hide()
		
	# Sets the player's health bar to the player's current health so that the player is
	# always aware of their health to decide their next action.
	health_ui.max_value = Global.player_base_health
	health_ui.value = Global.player_health
	health.text = str(Global.player_health)
	
	# Sets the player's health bar to the player's current health so that the player is
	# always aware of their health to decide their next action.
	sp_ui.max_value = Global.player_base_special
	sp_ui.value = Global.player_special
	sp.text = str(Global.player_special)
	
	# Sets the enemy's health bar so that the player is always aware of its health to 
	# decide their next action.
	potato_ui.max_value = Global.potato_health
	potato_ui.value = Global.potato_health
	potato_health.text = str(Global.potato_health)
	
	# If the player has not completed the fighting introduction yet, load in the items
	# used to introduce the player to the fighting mechanics.
	if Global.intro == false:
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.show()
		# Since the player's stats is the first thing getting introduced, bring it to
		# the front layer, above the shaded background to make it stand out.
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index -= second_layer
		text.text = intro[0]
		text.position = text_position_1
		sub_text.position = sub_text_position_1
		# During this time, prevent the players from interacting with any of the attack/
		# potion buttons as it may distract them from the tutorial.
		spell.mouse_filter = mouse_off
		potion.mouse_filter = mouse_off
		block.position = block_position_1
	else:
		# If the player has already completed the tutorial, then hide the items required
		# for the introduction and let them fight the enemy like normal.
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.hide()
		
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Sets the values of the potion the player has in their inventory to the ones they
	# can use in battle.
	soda_value.text = str(Global.inventory[purple_potion])
	just_water_value.text = str(Global.inventory[blue_potion])
	
	if potato_idle == true:
		potato.play("idle")
	
	# If the player does not have the pause menu opened them show all the UI elements.
	if Global.pause == false:
		pause_button.show()
		spell.show()
		potion.show()
	
	# If the player gets defeated by the enemy, load the main game and spawn them next
	# to the cauldron to refill their health and special points.
	if Global.player_health <= 0:
		Global.potato_fight = false
		Global.respawn = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")
	# If the player defeats the enemy and is currently doing their quest, add one more
	# enemy onto their quest counter as well as give the player a randomise sprout
	# reward from 1-3 when respawning them back into the main level. Also set the enemy
	# health max to the maximum for the next battle as well as changing the status of
	# the enemy fought to dead, so that it can respawn later on.
	elif Global.potato_health <= 0 and Global.quest_talk_finish == true:
		Global.potato_fight = false
		Global.money += reward_value
		Global.potato_health = potato_health_max
		Global.enemy_dict[Global.enemy_id] = potato_dead
		Global.quest_1_value += 1
		var random_sprout = randi_range(1,reward_range)
		Global.sprout_reward = random_sprout
		Global.sprout += random_sprout
		Global.battle_won = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")
	elif Global.potato_health <= 0:
		# If the player defeats the enemy give the player a randomise sprout reward from
		# 1-3 when respawning them back into the main level. Also set the enemy health
		# max to the maximum for the next battle as well as changing the status of the
		# enemy fought to dead, so that it can respawn later on.
		Global.potato_fight = false
		Global.money += reward_value
		Global.potato_health = potato_health_max
		Global.enemy_dict[Global.enemy_id] = potato_dead
		var random_sprout = randi_range(1,reward_range)
		Global.sprout_reward = random_sprout
		Global.sprout += random_sprout
		Global.battle_won = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")
	
	# If the player's health every goes over their maximum base health, bring it back
	# down to the maximum.
	if Global.player_health > Global.player_base_health:
		Global.player_health = Global.player_base_health
		health_ui.value = Global.player_health
		health.text = str(Global.player_health)	
		
	# If the player's special points every goes over their maximum base health, bring it
	# back down to the maximum.
	if Global.player_special > Global.player_base_special:
		Global.player_special = Global.player_base_special
		sp_ui.value = Global.player_special
		sp.text = str(Global.player_special)	
	
	# Bring the items in the turns to the front and items in the player's stats to the 
	# back when the player reaches that part of the tutorial, so they can understand how 
	# the turn system works.
	if counter == turns_intro:
		light_bar.hide()
		turns = true
		light_turns.show()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 0
				
		for items in canvas.get_children():
			if items.is_in_group("turns"):
				items.z_index += second_layer
	# Bring the items in the potato's health to the front and turns to the back when the
	# player reaches that part of the tutorial, so they can understand how the enemy's
	# health works.
	elif counter == potato_intro:
		bars = true
		for items in canvas.get_children():
			if items.is_in_group("turns"):
				items.z_index = -second_layer
				
		potato_bar.z_index = top_layer
		potato_hp.z_index = top_layer
		potato_health.z_index = top_layer
		potato_ui.z_index = second_layer
		
		light_turns.hide()
		light_potato.show()
		light_options.hide()
		
		# Moves the text box to the top of the screen, so it doesn't block the enemy's
		# health during the introduction on the enemy's health.
		block.position = block_position_2
		text.position = text_position_2
		sub_text.position = sub_text_position_2
	# Bring the items in the player's action to the front and enemy's health to the back
	# when the player reaches that part of the tutorial, so they can understand how their
	# actions work.
	elif counter == action_intro and clicked == false:
		light_potato.hide()
		light_options.show()
		potato_bar.z_index = 1
		potato_hp.z_index = 0
		potato_health.z_index = 0
		potato_ui.z_index = 0
		spell.z_index = second_layer
		potion.z_index = second_layer
		options = true
	# Allow the player to click on the spell action when they reach that stage of the
	# tutorial, so that the player understands what actions they could take.
	elif counter == spell_intro:
		spell.mouse_filter = mouse_on
		# When the player clicks on the wand/ action, load the dialogue to explain what
		# the actions do, so the player understands what to do in the future.
		if clicked == true and Global.pause == false:
			basic_spell_b.mouse_filter = mouse_off
			text.text = intro[click_dialogue]
			counter += 1
	# Allow the player to cast the spell after they've gone through the tutorial
	# explaining what it does.
	elif counter == cast_intro:
		basic_spell_b.mouse_filter = mouse_on
	
	# If the player has not completed the intro, start the tutorial and let them skip
	# through dialogue by cliking space.
	if Global.intro == false and Global.pause == false and bars == false and counter < start and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		light_bar.show()
		# The first thing that gets covered in the tutorial is the player's stats so
		# bring that to the front of the screen.
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.z_index = 1
				
	elif Global.intro == false and Global.pause == false and counter >= start and counter <turns_intro and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		light_bar.hide()
	
	elif Global.intro == false and Global.pause == false and counter >= turns_intro and options == false and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
				
	elif Global.intro == false and Global.pause == false and counter >= potato_intro and counter < spell_intro and options == true and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		
	elif Global.intro == false and Global.pause == false and counter >= spell_intro and counter < cast_intro and clicked == true and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		
	elif Global.pause == false and counter >= after_cast_intro and counter < end_intro and Input.is_action_just_pressed("next"):
		counter += 1
		text.text = intro[counter]
		
	elif counter == end_intro and Input.is_action_just_pressed("next"):
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.hide()


func _attack() -> void:
	if Global.intro == false:
		super_cast_b.hide()
		look_over_there_b.hide()
		spell_menu.show()
		spell_exit.show()
		spell_opened = true
		light_options.hide()
		clicked = true
	else:
		spell_exit.show()
		spell_menu.show()
		spell_opened = true
		wand_1 = true
		
	if potion_opened == true:
		potion_menu.hide()
		potion_exit.hide()
		spell_exit.show()
		spell_menu.show()
		spell_opened = true
		potion_opened = false
	else:
		spell_exit.show()
		spell_menu.show()
		spell_opened = true
		wand_1 = true

		if Global.shop[super_cast] == status_brought:
			super_cast_b.show()
		else:
			super_cast_b.hide()
		
		if Global.shop[look_over_there] == status_brought:
			look_over_there_b.show()
		else:
			look_over_there_b.hide()

func _potion() -> void:
	
	if spell_opened == true:
		spell_menu.hide()
		spell_exit.hide()
		spell_opened = false
		potion_opened = true
		potion_menu.show()
		potion_exit.show()
	else:
		potion_opened = true
		potion_menu.show()
		potion_exit.show()
	
	if Global.inventory[purple_potion] == 0:
		soda_b.hide()
	if Global.inventory[blue_potion] == 0:
		just_water_b.hide()


func _turn() -> void:
	if turns_left == second_turn:
		first_turn_p.visible = false 
		first_turn_w.visible = false 
		
	elif turns_left == 1:
		second_turn_p.visible = false 
		second_turn_w.visible = false 
	
	elif turns_left == 0:
		third_turn_p.visible = false 
		third_turn_w.visible = false 
		spell.mouse_filter = mouse_off
		potion.mouse_filter = mouse_off
		timer.start()
		
func _potato_attack() -> void:
	if turns_left == 0:
		potato_idle = false
		potato_animation.play("attack")
		Global.player_health -= 1
		health_ui.value = Global.player_health
		health.text = str(Global.player_health)


func _potato_heal() -> void:
	potato_idle = false
	potato.play("heal")
	potato_heal_timer.start()
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
	turns_left = turns_value
	first_turn_p.visible = true 
	first_turn_w.visible = true 
	second_turn_p.visible = true 
	second_turn_w.visible = true 
	third_turn_p.visible = true 
	third_turn_w.visible = true 

func _mistake_timeout() -> void:
	mistake_timer.stop()
	mistake.text = str(mistake_reset)

func _pause() -> void:
	pause.show()
	Global.pause = true
	pause_button.hide()
	spell.hide()
	potion.hide()


func _super_cast() -> void:
	if turns_left >= 1 and Global.player_special > 0:
		spell.mouse_filter = mouse_off
		potion.mouse_filter = mouse_off
		player.play("casting")
		fireball.show()
		fireball.play("summoning")
		fireball.position = fireball_starting
		spell_time.start()
		turns_left -= 1
		_turn()
		Global.potato_health -= super_cast_value
		Global.player_special -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special
		spell_opened = false
		spell_menu.hide()
		spell_exit.hide()
		
	elif Global.player_special < super_cast_v and turns_left >= 1:
		mistake.text = str(mistake_no_sp)
		mistake_timer.start()
		
	else:
		mistake.text = str(mistake_no_turn)
		mistake_timer.start()


func _basic_spell() -> void:
	if Global.intro == false and turns_left >= 1:
		spell.mouse_filter = mouse_off
		potion.mouse_filter = mouse_off
		player.play("casting")
		fireball.show()
		fireball.play("summoning")
		fireball.position = fireball_starting
		spell_time.start()
		turns_left -= 1
		_turn()
		Global.potato_health -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		spell_opened = false
		spell_menu.hide()
		spell_exit.hide()
		light_options.hide()
		intro_timer.start()
		
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.hide()
			elif items.is_in_group("turns"):
				items.z_index = 0
	elif turns_left >= 1 and Global.intro == true:
		spell.mouse_filter = mouse_off
		potion.mouse_filter = mouse_off
		player.play("casting")
		fireball.show()
		fireball.play("summoning")
		fireball.position = fireball_starting
		spell_time.start()
		turns_left -= 1
		_turn()
		Global.potato_health -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		spell_opened = false
		spell_menu.hide()
		spell_exit.hide()
	else:
		mistake.text = str(mistake_no_turn)
		mistake_timer.start()


func _spell_menu_exit() -> void:
	spell_opened = false
	spell_menu.hide()
	spell_exit.hide()


func _distract() -> void:
	if turns_left >= 1:
		spell.mouse_filter = mouse_off
		potion.mouse_filter = mouse_off
		player.play("casting")
		fireball.show()
		fireball.play("summoning")
		fireball.position = fireball_starting
		spell_time.start()
		turns_left -= 1
		_turn()
		potato_distract = true
		spell_opened = false
		spell_menu.hide()
		spell_exit.hide()
	else:
		mistake.text = str(mistake_no_turn)
		mistake_timer.start()


func _continue_intro() -> void:
	for items in canvas.get_children():
		if items.is_in_group("intro"):
			items.show()
		elif items.is_in_group("turns"):
			items.z_index = 0
	
	Global.intro = true	
	block.position = block_position_1
	text.position = text_position_1
	sub_text.position = sub_text_position_1
	counter += 1
	text.text = intro[counter]


func _exit_potion() -> void:
	potion_exit.hide()
	potion_menu.hide()


func _purple_potion() -> void:
	if turns_left >= 1 and Global.player_special < Global.player_base_special and Global.inventory[purple_potion] >= 1:
		player.play("potion")
		Global.inventory[purple_potion] -= 1
		soda_value.text = str(Global.inventory[purple_potion])
		turns_left -= 1
		_turn()
		Global.player_special += purple_potion_effect
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special
		potion_exit.hide()
		potion_menu.hide()
	elif Global.player_special == Global.player_base_special:
		mistake.text = str("Special points already maxed!")
		mistake_timer.start()
	elif Global.inventory[purple_potion] == 0:
		soda_b.hide()
	else:
		mistake.text = str(mistake_no_turn)
		mistake_timer.start()


func _blue_potion() -> void:
	if turns_left >= 1 and (Global.player_special < Global.player_base_special or Global.player_health < Global.player_base_health) and Global.inventory[blue_potion] >= 1:
		player.play("potion")
		Global.inventory[blue_potion] -= 1
		soda_value.text = str(Global.inventory[blue_potion])
		turns_left -= 1
		_turn()
		Global.player_special += blue_potion_effect_sp
		Global.player_health += blue_potion_effect_hp
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special
		health.text = str(Global.player_health)
		health_ui.value = Global.player_health
		potion_exit.hide()
		potion_menu.hide()
	elif Global.player_special == Global.player_base_special:
		mistake.text = str(mistake_maxed)
		mistake_timer.start()
	elif Global.inventory[blue_potion] == 0:
		just_water_b.hide()
	else:
		mistake.text = str(mistake_no_turn)
		mistake_timer.start()


func _cast() -> void:
	fireball.play("flying")
	fireball_animation.play("fireball")
	spell_time.stop()
	

func _fireball_finish(anim_name: StringName) -> void:
	if turns_left > 0:
		spell.mouse_filter = mouse_on
		potion.mouse_filter = mouse_on


func _potato_finish(anim_name: StringName) -> void:
	potato.play("attack_end")
	potato_idle_timer.start()
	spell.mouse_filter = mouse_on
	potion.mouse_filter = mouse_on


func _potato_idle() -> void:
	potato_idle = true
	potato_idle_timer.stop()


func _potato_heal_time() -> void:
	potato_idle = true
	potato_heal_timer.stop()
	spell.mouse_filter = mouse_on
	potion.mouse_filter = mouse_on
