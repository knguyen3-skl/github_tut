extends Node2D
@export var health_ui: ProgressBar
@export var sp_ui: ProgressBar
@export var potato_ui: ProgressBar
@export var health: Label
@export var sp: Label
@export var potato_health: Label

@export var first_turn_p: Panel
@export var first_turn_w: Sprite2D
@export var second_turn_p: Panel
@export var second_turn_w: Sprite2D
@export var third_turn_p: Panel
@export var third_turn_w: Sprite2D

@export var timer: Timer
@export var mistake_timer: Timer
@export var mistake: Label

@export var spell: Button
@export var potion: Button

@export var pause: ColorRect
@export var pause_button: Button

@export var canvas: CanvasLayer
@export var dark: Polygon2D
@export var light: Polygon2D
@export var block: NinePatchRect
@export var text: Label
@export var sub_text: Label

var bars: bool = false

var turns_left: int = 3
var potato_turns: int = 1
var basic_spell: int = 1

var intro = [
	"This is a quick introduction to mastering
combat!",
"In the top left is your health and special 
points",
"Whenever you get attacked, you will lose
health, so be careful and don't go below 0",
"Special points can be used to cast spells, so
remember to recharge them",

]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.potato_fight = true
	health_ui.max_value = Global.player_base_health
	health_ui.value = Global.player_health
	health.text = str(Global.player_health)
	
	sp_ui.max_value = Global.player_base_special
	sp_ui.value = Global.player_special
	sp.text = str(Global.player_special)
	
	potato_ui.max_value = Global.potato_health
	potato_ui.value = Global.potato_health
	potato_health.text = str(Global.potato_health)
	
	pause.hide()
	
	if Global.intro == false:
		for items in canvas.get_children():
			if items.is_in_group("intro"):
				items.show()
				
		text.text = intro[0]
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.pause == false:
		pause_button.show()
		spell.show()
		potion.show()
	
	if Global.player_health <=0:
		Global.potato_fight = false
		get_tree().call_deferred("change_scene_to_file", "res://scenes/died.tscn")
	elif Global.potato_health == 0:
		Global.potato_fight = false
		print(Global.potato_fight)
		Global.money += 10
		Global.potato_health = 10
		Global.enemy_dict[Global.enemy_id] = "dead"
		print(Global.enemy_dict)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level.tscn")
		
	if Global.intro == false and bars == false and Input.is_action_just_pressed("next"):
		text.text = intro[1]
		light.show()

func _attack() -> void:
	if turns_left >= 1 and Global.player_special > 0:
		turns_left -= 1
		_turn()
		Global.potato_health -= 1
		Global.player_special -= 1
		potato_ui.value = Global.potato_health
		potato_health.text = str(Global.potato_health)
		sp.text = str(Global.player_special)
		sp_ui.value = Global.player_special
		
	elif Global.player_special < basic_spell and turns_left >= 1:
		mistake.text = str("Not enough special points!")
		mistake_timer.start()

func _potion() -> void:
	if turns_left >= 1 and Global.player_special < Global.player_base_special:
		turns_left -= 1
		_turn()
		Global.player_special += 1
		sp_ui.value = Global.player_special
		sp.text = str(Global.player_special)
	
	elif Global.player_special == Global.player_base_special and turns_left >= 1:
		mistake.text = str("Special Points is already maxed!")
		mistake_timer.start()
		
func _turn() -> void:
	if turns_left == 2:
		first_turn_p.visible = false 
		first_turn_w.visible = false 
		
	elif turns_left == 1:
		second_turn_p.visible = false 
		second_turn_w.visible = false 
	
	elif turns_left == 0:
		third_turn_p.visible = false 
		third_turn_w.visible = false 
		timer.start()
		
func _potato_attack() -> void:
	if turns_left == 0:
		Global.player_health -= 1
		health_ui.value = Global.player_health
		health.text = str(Global.player_health)

func _potato_heal() -> void:
	Global.potato_health += 1
	potato_ui.value = Global.potato_health
	potato_health.text = str(Global.potato_health)

func _potato_turn() -> void:
	if potato_turns == 1:
		_potato_attack()
		timer.stop()
		_turn_reset()
		potato_turns -= 1
		
	else:
		_potato_heal()
		timer.stop()
		_turn_reset()
		potato_turns += 1
	
func _turn_reset() -> void:
	turns_left = 3
	first_turn_p.visible = true 
	first_turn_w.visible = true 
	second_turn_p.visible = true 
	second_turn_w.visible = true 
	third_turn_p.visible = true 
	third_turn_w.visible = true 

func _mistake_timeout() -> void:
	mistake_timer.stop()
	mistake.text = str("")

func _pause() -> void:
	pause.show()
	Global.pause = true
	pause_button.hide()
	spell.hide()
	potion.hide()
