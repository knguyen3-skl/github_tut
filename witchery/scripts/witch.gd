extends CharacterBody2D

@export var player: AnimatedSprite2D

var speed: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.last_player_positon = global_position
	var direction: Vector2 = Vector2(0.0,0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	velocity = speed * direction.normalized()
	
	if Input.get_axis("ui_left", "ui_right"):
		player.animation = "walk"
		if direction.x == -1:
			player.flip_h = true
		else:
			player.flip_h = false
	else:
		player.animation = "idle"
	move_and_slide()
	
