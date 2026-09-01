extends Node

var money: int = 0
var sprout: int = 0

var potato_fight: bool = false

var player_base_health: int = 10
var player_base_special: int = 5

var player_health: int = 10
var player_special: int = 5

var potato_health: int = 10
var battle_won: bool = false
var respawn: bool = false

var enemy_dict= {}
var enemy_status: bool = true

var enemy_id: String

var potion_brewing: bool = false
var last_player_positon = Vector2(-262.0, 210.0)

var inventory_status: bool = false
var pause: bool = false
var talking: bool = false
var market: bool = false
var shop_speech: bool = false

var inventory = {
	"purple_potion": 1,
	"blue_potion": 1,
}

var shop = {
	"super_cast": "yes",
	"look_over_there": "yes",
}

var intro: bool = true
var quest_1_value: int = 2
var quest_talk: bool = false
var quest_talk_finish: bool = false
var quest_complete: bool = false

var sprout_reward = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
