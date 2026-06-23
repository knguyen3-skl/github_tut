extends ColorRect

@export var timer: Timer

@export var money: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _brewed() -> void:
	if Global.money >= 20:
		Global.money -= 20
		money.text = str(Global.money)
		Global.inventory["purple_potion"] += 1
		print("purple_potion")
		print(Global.inventory)
	else:
		print("brokie")
		$Label4.show()
		timer.start()
		

func _exit_brewing() -> void:
	hide()


func _on_timer_timeout() -> void:
	$Label4.hide()
