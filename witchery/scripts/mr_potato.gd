extends CharacterBody2D

@export var navigation_agent_2d: NavigationAgent2D
@export var player: CharacterBody2D
@export var animation: AnimatedSprite2D

var speed: int = 70
var ROLL: int = 5
var direction : Vector2
var stationary : Vector2
var stop = Vector2(0.0, 0.0)

func _ready() -> void:
	# check in dict if defeated
	# enemy's starting position
	stationary = global_position
	

func _physics_process(delta: float) -> void:
	
	if Global.pause == true:
		velocity = stop
		speed = 0
	else:
		speed = speed
	
	# the goal of the enemy
	navigation_agent_2d.target_position = player.global_position
	# where the enemy goes
	direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
	
	if navigation_agent_2d.is_target_reachable() == false:
		navigation_agent_2d.target_position = stationary
		direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
		animation.animation = "walk"
		animation.rotate(delta * ROLL)
		velocity = velocity.lerp(direction * speed, delta)
		move_and_slide()

	
	# if the enemy has not reached the player yet
	elif navigation_agent_2d.is_target_reached() == false:
		velocity = velocity.lerp(direction * speed, delta)
		animation.animation = "walk"
		animation.rotate(delta * ROLL)
		move_and_slide()

func _mr_potato_fight(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.enemy_id = self.name
		get_tree().call_deferred("change_scene_to_file", "res://scenes/fight_mr_potato.tscn")
