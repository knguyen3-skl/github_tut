extends CharacterBody2D

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
		$AnimatedSprite2D.animation = "walk"
		if direction.x == -1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.animation = "idle"
	move_and_slide()
	
