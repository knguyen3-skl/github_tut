extends CharacterBody2D

var speed: int = 100

@export var player: AnimatedSprite2D

@onready var walking_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walking_sfx.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Takes in the user's input and moves the character acordingly
	Global.last_player_positon = global_position
	var direction: Vector2 = Vector2(0.0,0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	velocity = speed * direction.normalized()
	
	
	# Runs walking animation if the player goes left or right
	if Input.get_axis("ui_left", "ui_right") and Global.talking == false:
		player.animation = "walk"
		if direction.x == -1:
			player.flip_h = true
		else:
			player.flip_h = false
		if Global.sound_effects == true and Global.pause == false:
			print("you")
			walking_sfx.stream_paused = false
	elif Input.get_axis("ui_up", "ui_down"):
		if Global.sound_effects == true and Global.pause == false:
			print("me")
			walking_sfx.stream_paused = false
	else:
		player.animation = "idle"
		walking_sfx.stream_paused = true
		
	move_and_slide()
