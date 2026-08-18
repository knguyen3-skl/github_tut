extends Node2D

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
@export var coins: Label
@export var pause: Button
@export var speech_block: ColorRect
@export var canvas: CanvasLayer
@export var quest: ColorRect
@export var sprout: Label
@export var announcement: ColorRect
@export var timer_msg: Timer
@export var dialogue_scene = preload("res://scenes/balloon.tscn")
@export var dialogue = preload("res://dialogue/pencil_dialogue.dialogue")
@export var mr_pencil = StaticBody2D

var timer: bool = false
var start_pos = Vector2(-262.0, 210.0)
var status_alive: String = "alive"
var status_dead: String = "dead"
var respawn_time: int = 30


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# if dialogue and Global.quest_talk == false:
	#	Global.questtalk_ = true:
	# DialogueManager.show_dialogue_balloon(dialogue, "start")
	
	speech_block.hide()
	quest.hide()
	print(Global.last_player_positon)
	player_health.max_value = Global.player_base_health
	player_health.value = Global.player_health
	health.text = str(Global.player_health)
	
	player_special.max_value = Global.player_base_special
	player_special.value = Global.player_special
	special.text = str(Global.player_special)
	
	sprout.text = str(Global.sprout)
	
	if Global.last_player_positon == start_pos:
		pass
	else:
		player.global_position = Global.last_player_positon
	
	money.text = str(Global.money)
	if Global.enemy_dict == {}:
		# get every enemy and add to dict
		for enemies in get_tree().get_nodes_in_group("enemy"):
			# add the status key
			Global.enemy_dict[enemies.name] = status_alive
		print(Global.enemy_dict)
	
	for enemies in get_tree().get_nodes_in_group("enemy"):
		if Global.enemy_dict[enemies.name] == status_dead:
			enemies.hide()
			enemies.get_child(2).monitoring = false
			enemies.get_child(1).disabled = true
			enemies.set_physics_process(false)
			get_tree().create_timer(respawn_time).connect("timeout", _respawn_enemy.bind(enemies.name))
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprout.text = str(Global.sprout)
	money.text = str(Global.money)
	# if alive show
	# if dead hide + untouchable
	for enemies in get_tree().get_nodes_in_group("enemy"):
		if Global.enemy_dict[enemies.name] == status_alive:
			enemies.show()
			enemies.get_child(2).monitoring = true
			enemies.get_child(1).disabled = false
			enemies.set_physics_process(true)
	
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
		player.speed = 100
		inventory.show()
		pause.show()

		money.show()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.show()
			elif items.is_in_group("collect"):
				items.show()
				
				
	if Global.quest_1_talk == true:
		quest.show()
				
	if Global.battle_won == true and timer == false:
		announcement.show()
		for items in announcement.get_children():
			if items.is_in_group("rewards"):
				items.show()
			else:
				items.hide()
		timer_msg.start()
		timer = true
	
	
func _respawn_enemy(enemy_id: StringName) -> void:
	Global.enemy_dict[enemy_id] = status_alive
	print(Global.enemy_dict)


func _rewards() -> void:
	announcement.hide()
