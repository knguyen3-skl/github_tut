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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speech_block.hide()
	print(Global.last_player_positon)
	player_health.max_value = Global.player_base_health
	player_health.value = Global.player_health
	health.text = str(Global.player_health)
	
	player_special.max_value = Global.player_base_special
	player_special.value = Global.player_special
	special.text = str(Global.player_special)
	
	if Global.last_player_positon == Vector2(-262.0, 210.0):
		pass
	else:
		player.global_position = Global.last_player_positon
	
	money.text = str(Global.money)
	if Global.enemy_dict == {}:
		# get every enemy and add to dict
		for enemies in get_tree().get_nodes_in_group("enemy"):
			# add the status key
			Global.enemy_dict[enemies.name] = "alive"
		print(Global.enemy_dict)
	
	for enemies in get_tree().get_nodes_in_group("enemy"):
		if Global.enemy_dict[enemies.name] == "dead":
			enemies.hide()
			enemies.get_child(2).monitoring = false
			enemies.get_child(1).disabled = true
			enemies.set_physics_process(false)
			get_tree().create_timer(30).connect("timeout", _respawn_enemy.bind(enemies.name))
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# if alive show
	# if dead hide + untouchable
	for enemies in get_tree().get_nodes_in_group("enemy"):
		if Global.enemy_dict[enemies.name] == "alive":
			enemies.show()
			enemies.get_child(2).monitoring = true
			enemies.get_child(1).disabled = false
			enemies.set_physics_process(true)
	
	if Global.pause == true:
		for items in canvas.get_children():
			if items.is_in_group("stats"):
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
		coins.show()
		money.show()
		for items in canvas.get_children():
			if items.is_in_group("stats"):
				items.show()

func _respawn_enemy(enemy_id: StringName) -> void:
	Global.enemy_dict[enemy_id] = "alive"
	print(Global.enemy_dict)
