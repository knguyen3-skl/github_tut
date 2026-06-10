extends CharacterBody2D

@export var navigation_agent_2d: NavigationAgent2D
@export var player : CharacterBody2D

const SPEED = 200
var direction : Vector2
var stationary : Vector2

func _ready() -> void:
	stationary = global_position
	

func _physics_process(delta: float) -> void:
	_chase_player()
	if !navigation_agent_2d.is_target_reachable():
		navigation_agent_2d.target_position = stationary
	
	elif navigation_agent_2d.is_target_reached() == false:
		direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
		velocity = velocity.lerp(direction * SPEED, delta)
		move_and_slide()
		
	elif navigation_agent_2d.is_target_reachable() == false:
		navigation_agent_2d.target_position = stationary
		direction = stationary
		velocity = velocity.lerp(direction * SPEED, delta)
		move_and_slide()
		
func _chase_player() -> void:
	navigation_agent_2d.target_position = player.global_position
	
