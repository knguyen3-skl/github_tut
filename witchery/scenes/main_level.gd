extends Node2D

@export var money: Label
@export var potato_respawn: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money.text = str(Global.money)
	if Global.enemy_dict == {}:
		# get every enemy and add to dict
		for enemies in get_tree().get_nodes_in_group("enemy"):
			# add the status key
			Global.enemy_dict[enemies.name] = "alive"
		print(Global.enemy_dict)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# if alive show
	# if dead hide + untouchable
	for enemies in get_tree().get_nodes_in_group("enemy"):
		if Global.enemy_dict[enemies.name] == "dead" and potato_respawn.is_stopped():
			enemies.hide()
			enemies.get_child(2).monitoring = false
			enemies.get_child(1).disabled = true
			enemies.set_physics_process(false)
			potato_respawn.start()
			
		elif Global.enemy_dict[enemies.name] == "alive":
			enemies.show()
			enemies.get_child(2).monitoring = true
			enemies.get_child(1).disabled = false
			enemies.set_physics_process(true)

func _respawn_enemy() -> void:
	Global.enemy_dict[Global.enemy_id] = "alive"
	print(Global.enemy_dict)
	potato_respawn.stop()
