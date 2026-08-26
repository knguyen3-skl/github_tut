extends Node2D

var timer: bool = false
var status_alive: String = "alive"
var status_dead: String = "dead"
var respawn_time: int = 30
var quest_repeat: bool = false
var potato_defeated: int = 3
var quest_complete_repeat: bool = false
var complete_dialogue: bool = false
var reward_money: int = 100
var respawn_position = Vector2(-200.0,354.0)
var player_speed: int = 100
var enemy_collison: int = 1
var enemy_area2D: int = 2

@export var money: Label
@export var player: CharacterBody2D
@export var player_health: ProgressBar
@export var player_special: ProgressBar
@export var health: Label
@export var special: Label
@export var hp_bar: Sprite2D
@export var sp_bar:Sprite2D
@export var heart:Sprite2D
@export var energy:Sprite2D
@export var inventory: Button
@export var pause: Button
@export var canvas: CanvasLayer
@export var quest: ColorRect
@export var sprout: Label
@export var announcement: ColorRect
@export var timer_msg: Timer
@export var dialogue_scene = preload("res://scenes/balloon.tscn")
@export var dialogue = preload("res://dialogue/pencil_dialogue.dialogue")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	announcement.hide()
	quest.hide()
	# Sets the healthbar and special points bar to the current player's health/
	# special points.
	print(Global.last_player_positon)
	player_health.max_value = Global.player_base_health
	player_health.value = Global.player_health
	health.text = str(Global.player_health)
	
	player_special.max_value = Global.player_base_special
	player_special.value = Global.player_special
	special.text = str(Global.player_special)
	
	# Sets the label for the amount of sprouts and money to the amount owned.
	sprout.text = str(Global.sprout)
	money.text = str(Global.money)
		
	# Checks to see if the player has won their last battle or not, an if they did,
	# respawn them where they were before battle, but if not, spawn them next to the
	# cauldron to regain their health and special points.
	if Global.respawn == true:
		player.global_position = respawn_position
		Global.respawn = false
	else:
		player.global_position = Global.last_player_positon
	
	# Tracks the amount of enemies avaliable and set them to alive when first loading
	# the main level for the first time, so that they can spawn when alive, and despawn
	# when defeated.
	if Global.enemy_dict == {}:
		# Get every enemy and add to dictionary.
		for enemies in get_tree().get_nodes_in_group("enemy"):
			# Add the status key.
			Global.enemy_dict[enemies.name] = status_alive
		print(Global.enemy_dict)
	
	# Checks every enemy if they're dead or not, and if they are, hide them, turn off 
	# their collision and area monitoring, so that the player does not interact with a
	# defeated enemy.
	for enemies in get_tree().get_nodes_in_group("enemy"):
		if Global.enemy_dict[enemies.name] == status_dead:
			enemies.hide()
			enemies.get_child(enemy_area2D).monitoring = false
			enemies.get_child(enemy_collison).disabled = true
			enemies.set_physics_process(false)
			# Runs a timer to respawn the enemy that was just defeated after battle.
			get_tree().create_timer(respawn_time).connect("timeout", _respawn_enemy.bind(enemies.name))
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprout.text = str(Global.sprout)
	money.text = str(Global.money)
	
	# If the player is involved in dialogue with an NPC, hide all the UI elements so
	# that the player does not get ditracted.
	if Global.talking == true:
		inventory.hide()
		pause.hide()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.hide()
			elif items.is_in_group("collect"):
				items.hide()
	# If the player is not talking to an NPC, display all of the UI elements again.
	else:
		inventory.show()
		pause.show()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.show()
			elif items.is_in_group("collect"):
				items.show()
	
	# If the player has talked to the NPC and have not completed the quest yet, show the
	# quest pop up to inform the player of their objective.
	if Global.quest_talk_finish == true and Global.quest_complete == false:
		quest.show()
	else:
		quest.hide()
	
	# If the player is talking to the NPC, but has not completed any of the dialogue,
	# play the dialogue from the begining.
	if Global.talking == true and Global.quest_talk == false and dialogue:
		DialogueManager.show_dialogue_balloon(dialogue, "start")
		DialogueManager.dialogue_ended.connect(_quest)
		Global.quest_talk = true
	# If the player has finished talking to the NPC, but has not completed the quest
	# yet, let the NPC remind the player of their objective again, so that the player
	# understands what they need to do.
	elif Global.quest_talk_finish == true and Global.talking == true and quest_repeat == false and Global.quest_1_value < potato_defeated:
		DialogueManager.show_dialogue_balloon(dialogue, "repeat")
		quest_repeat = true
		DialogueManager.dialogue_ended.connect(_quest_repeat)
	# If the player has completed the quest, but has not talked to the NPC, then load
	# the dialogue where the NPC thanks the player and rewards them for their effors.
	elif Global.quest_1_value >= potato_defeated and Global.talking == true and Global.quest_complete == false:
		Global.quest_complete = true
		quest.hide()
		DialogueManager.show_dialogue_balloon(dialogue, "finished")
		DialogueManager.dialogue_ended.connect(_quest_finished)
	# If the player has completed the quest and talked to the NPC already, let the NPC
	# tell the player that there is nothing else that they want the player to do at the
	# moment.
	elif Global.quest_complete == true and Global.talking == true and quest_complete_repeat == false and complete_dialogue == true:
		quest_complete_repeat = true
		DialogueManager.show_dialogue_balloon(dialogue, "snipet")
		DialogueManager.dialogue_ended.connect(_quest_complete)
		
	# If the enemy is alive, show it as well as turn on it's area monitoring and
	# collision.
	for enemies in get_tree().get_nodes_in_group("enemy"):
		if Global.enemy_dict[enemies.name] == status_alive:
			enemies.show()
			enemies.get_child(enemy_area2D).monitoring = true
			enemies.get_child(enemy_collison).disabled = false
			enemies.set_physics_process(true)
	
	# If the pause menu is opened, hide all the UI elements and stop player movement, so
	# that the player does not get ditracted.
	if Global.pause == true:
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.hide()
			elif items.is_in_group("collect"):
				items.hide()
		inventory.hide()
		pause.hide()
		player.speed = 0
	elif Global.talking == true:
		player.speed = 0
	else:
		# If the player is not involved in NPC interaction or the pause menu, display
		# all the UI elements again for the player to play the game.
		player.speed = player_speed
		inventory.show()
		pause.show()
		money.show()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.show()
			elif items.is_in_group("collect"):
				items.show()
				
	# Checks if the last battle was won and shows the player the rewards they recieved
	# as soon as they come out from battle.
	if Global.battle_won == true and timer == false:
		announcement.show()
		for items in announcement.get_children():
			if items.is_in_group("rewards"):
				items.show()
			else:
				items.hide()
		timer_msg.start()
		timer = true
		Global.battle_won = false
	

# Acts as a respawn timer, and sets an enemy status to alive so that it can respawn
# again for the player to fight and defeat.
func _respawn_enemy(enemy_id: StringName) -> void:
	Global.enemy_dict[enemy_id] = status_alive
	print(Global.enemy_dict)


# Hides the rewards announcement after a period of time so that the player can be
# informed about their rewards as well as play the game normally.
func _rewards() -> void:
	announcement.hide()


# Show the quest pop up after the player has talked to the NPC for the first time and
# set the talking status to false as well as quest talk to true.
func _quest(_resource):
	quest.show()
	Global.talking = false
	Global.quest_talk_finish = true
	

# After the player has talked to the NPC whilst have not done their quest yet, set
# talking status and quest repeat to false so that the NPC can remind the player of
# their objective again if they still haven't completed it.
func _quest_repeat(_resource):
	Global.talking = false
	quest_repeat = false


# When the player has talked to the NPC after completing the quest, give thier reward
# money as well as setting the talking status to false and complete dialogue to true.
func _quest_finished(_resource):
	Global.talking = false
	complete_dialogue = true
	Global.money += reward_money


# Set talking and quest complete repeat to false when the player talks to the PC after
# completing the quest so that it keeps loading the same dialogue telling the player
# that there's nothing left to do.
func _quest_complete(_resource):
	Global.talking = false
	quest_complete_repeat = false
