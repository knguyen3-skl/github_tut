extends Node2D

@export var money: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
			get_tree().create_timer(60).connect("timeout", _respawn_enemy.bind(enemies.name))
			
			
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

func _respawn_enemy(enemy_id: StringName) -> void:
	Global.enemy_dict[enemy_id] = "alive"
	print(Global.enemy_dict)
