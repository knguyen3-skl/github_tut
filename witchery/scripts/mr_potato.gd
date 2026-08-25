extends CharacterBody2D

var speed: int = 70
var og_speed: int = 70
var ROLL: int = 5
var direction : Vector2
var stationary : Vector2
var stop = Vector2(0.0, 0.0)

@export var navigation_agent_2d: NavigationAgent2D
@export var player: CharacterBody2D
@export var animation: AnimatedSprite2D


func _ready() -> void:
	stationary = global_position
	

func _physics_process(delta: float) -> void:
	
	if Global.pause == true:
		velocity = stop
		speed = 0
	else:
		speed = og_speed
	
	# Sets the goal of the enemy to the player's position
	navigation_agent_2d.target_position = player.global_position
	direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
	
	# If the enemy cannot reach the player/ the player is not within it's navigation
	# Region, then it will return to it's orignal position.
	if navigation_agent_2d.is_target_reachable() == false:
		navigation_agent_2d.target_position = stationary
		direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
		animation.animation = "walk"
		animation.rotate(delta * ROLL)
		velocity = velocity.lerp(direction * speed, delta)
		move_and_slide()

	
	# if the enemy has not reached the player yet then chase the player.
	elif navigation_agent_2d.is_target_reached() == false:
		velocity = velocity.lerp(direction * speed, delta)
		animation.animation = "walk"
		animation.rotate(delta * ROLL)
		move_and_slide()


func _mr_potato_fight(area: Area2D) -> void:
	# If the enemy comes in contact with the player, fight them.
	if area.is_in_group("player"):
		Global.enemy_id = self.name
		get_tree().call_deferred("change_scene_to_file", "res://scenes/fight_mr_potato.tscn")
